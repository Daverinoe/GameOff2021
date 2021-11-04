extends KinematicBody2D

## Expose these variables to the inspector
# Combat variables
export(int, 1, 3) var damage : int = 1
export(int, 3, 10) var health : int = 3

# Movement variables
export(int, 0, 1000) var maxSpeed : int = 700
export(float, 0, 1000) var gravity : float = 98
export(float, 1.0, 10) var acceleration : float = 5.0 # (Higher = slower)
export(float, 1.0, 10) var deceleration : float = 5.0
export(float, 0.0, 3000) var terminalVelocity : float = 2000 # Hopefully ~ 200 m/s, which is human terminal velocity. Roughly.

export(float, 0.0, 300) var jumpSpeed : float = 800
export(float, 1.0, 300) var jumpAcceleration : float = 100



# Intermediary variables
var direction := Vector2()
var velocity := Vector2()

# Constants
var jumping : bool = true
var falling : bool = true
onready var gravityStore = gravity
var isHit : bool = false

func _process(_delta: float) -> void:
	# Get the input here so that we don't miss any inputs due to the set update of _physics_process
	get_input_and_set_direction()
	get_input_and_set_jump()


func _physics_process(delta: float) -> void:
	set_velocity()
	check_floor() # Check floor after setting velocity otherwise we can never jump
	velocity = move_and_slide(velocity, Vector2.UP)
	check_coyote(delta) # Check for coyote after moving so that we can turn gravity off if we need to
	check_enemy_collision()


func get_input_and_set_direction() -> void:
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		direction.x = 0
	elif Input.is_action_pressed("move_left"):
		direction.x = -1
		$Sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
		$Sprite.flip_h = false
	else:
		direction.x = 0

func get_input_and_set_jump() -> void:
	if Input.is_action_just_pressed("jump") and !jumping:
		velocity.y = 0 # Do a velocity check here so velocity change later is instantaneous
		jumping = true
	if Input.is_action_just_released("jump") and jumping:
		falling = true

func set_velocity() -> void:
	if !isHit:
		# Left and right movement (lerp looks nice, though might try different erp functions)
		if direction.x != 0:
			velocity.x = lerp(velocity.x, direction.x * maxSpeed, 1/acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, 1/deceleration)
	
	# Up movement
	if jumping and !falling:
		if velocity.y > -jumpSpeed: # We don't want to accelerate forever
			velocity.y -= gravity + jumpAcceleration
		else:
			falling = true # We don't want to fly (at least, not by pressing jump)
	
#	if jumping and falling:
#		gravity = 1.5 * gravityStore  # We can uncomment this if we want to fall faster after jumping
	
	# Down movement (gravity)
	if velocity.y <= terminalVelocity and $CoyoteTimer.is_stopped():
		velocity.y += gravity
	

func check_floor():
	if is_on_floor() and falling:
		gravity = gravityStore
		falling = false
		jumping = false
		$CoyoteTimer.stop()

func check_coyote(delta):
	# If the coyote timer isn't running and we walk off of an edge, start the coyote timer
	if !is_on_floor() and !falling and !jumping and $CoyoteTimer.is_stopped():
		gravity = 0
		position.y -= velocity.y * delta # Offset by this because I couldn't think of another way to counter the small drop
		velocity.y = 0
		$CoyoteTimer.start()

func _on_CoyoteTimer_timeout() -> void:
	gravity = gravityStore
	if !jumping: # We need to set either jumping or falling to true, otherwise we get stuck in an endless loop of coyote timer
		falling = true

func check_enemy_collision() -> void:
	for slide in get_slide_count():
		var collision = get_slide_collision(slide)
		if collision.collider.is_in_group("Enemy"):
			take_damage(collision.collider.damage)

func take_damage(damageTaken: int) -> void:
	# Play damage animation
	# Turn movement off
	isHit = true
	# Take damage
	health -= damageTaken
	# Start timer to not take damage again
	$HitTimer.start()
	$AnimationPlayer.play("TakeDamage")
	$MovementPauseTimer.start()
	 # Turn off collision so we don't hit things until after the hit timer expires
	set_collision(1, false)


func _on_HitTimer_timeout() -> void:
	# Turn collision back on
	set_collision(1, true)


func _on_MovementPauseTimer_timeout() -> void:
	# Turn movement back on
	isHit = false

func set_collision(bit: int, state: bool) -> void:
	set_collision_layer_bit(bit, state)
	set_collision_mask_bit(bit, state)
