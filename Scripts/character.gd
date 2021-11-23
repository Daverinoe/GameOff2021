extends KinematicBody2D

## Expose these variables to the inspector
# Combat variables
export(int, 3, 10) var health : int = 3

# Movement variables
export(int, 0, 1000) var maxSpeed : int = 700
export(float, 0, 1000) var gravity : float = 98
export(float, 1.0, 10) var acceleration : float = 5.0 # (Higher = slower)
export(float, 1.0, 10) var deceleration : float = 5.0
export(float, 0.0, 3000) var terminalVelocity : float = 2000 # Hopefully ~ 200 m/s, which is human terminal velocity. Roughly.

export(float, 0.0, 300) var jumpSpeed : float = 800
export(float, 1.0, 300) var jumpAcceleration : float = 100

var jumpParticlesScene : PackedScene = preload("res://Scenes/characterdetail/FootPuffs.tscn")

# Intermediary variables
var direction := Vector2.RIGHT
var velocity := Vector2()

# Constants
var jumping : bool = true
var doubleJump : bool = false
var falling : bool = true
onready var gravityStore = gravity
onready var speed = maxSpeed
var isHit : bool = false
var isChangingLevel : bool = false
var isMoving : bool = false # Use this to double-check collisions with enemies

# Powerups
export var doubleRunSpeedCollected = false
export var doubleShootSpeedCollected = false
export var doubleBulletSpeedCollected = false
export var doubleJumpCollected = true

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
		speed = 0
	elif Input.is_action_pressed("move_left"):
		direction.x = -1
		speed = maxSpeed
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
		speed = maxSpeed
	else:
		speed = 0
	
	if Input.is_action_just_pressed("move_left"):
		self.rotation = deg2rad(180)
		self.scale.y = -1
	elif Input.is_action_just_pressed("move_right"):
		self.rotation = 0
		self.scale.y = 1

func get_input_and_set_jump() -> void:
	if Input.is_action_just_pressed("jump") and (!jumping or (!doubleJump and doubleJumpCollected)):
		velocity.y = 0 # Do a velocity check here so velocity change later is instantaneous
		if jumping:
			doubleJump = true
		jumping = true
		falling = false
		$JumpSound.play()
		$JumpSound.pitch_scale = rand_range(0.9, 1.1)
		
	if Input.is_action_just_released("jump") and jumping:
		falling = true

func set_velocity() -> void:
	# Check for non-movement first
	if abs(velocity.x) > 0.1 or abs(velocity.y) > 0.1:
		isMoving = true
	else:
		isMoving = false
	
	if abs(velocity.x) > 0.1 and $Footsteps/Timer.is_stopped() and is_on_floor():
		$Footsteps/Timer.start()
	elif abs(velocity.x) < 0.1 and !$Footsteps/Timer.is_stopped() or !is_on_floor():
		$Footsteps/Timer.stop()
		$Footsteps/Timer.wait_time = 0.05
	
	if !isHit and !isChangingLevel:
		# Left and right movement (lerp looks nice, though might try different erp functions)
		if direction.x != 0:
			velocity.x = lerp(velocity.x, direction.x * speed, 1/acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, 1/deceleration)
	
	# Up movement
	if jumping and !falling and !isChangingLevel:
		if velocity.y > -jumpSpeed: # We don't want to accelerate forever
			velocity.y -= gravity + jumpAcceleration
		elif !doubleJump:
			falling = true # We don't want to fly (at least, not by pressing jump)
	
	if doubleJump and !falling:
		if velocity.y > -jumpSpeed: # We don't want to accelerate forever
			velocity.y -= gravity + jumpAcceleration
		else:
			falling = true # We don't want to fly (at least, not by pressing jump)
	
	if isChangingLevel:
		velocity.x = 0
		velocity.y = 0
	
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
		doubleJump = false
		$CoyoteTimer.stop()
		var jumpParts = jumpParticlesScene.instance()
		jumpParts.process_material.initial_velocity = direction.x * 10
		jumpParts.emitting = true
		self.call_deferred("add_child", jumpParts)

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
	if !isHit:
		for slide in get_slide_count():
			var collision = get_slide_collision(slide)
			if collision.collider.is_in_group("Enemy"):
				take_damage(collision.collider.damage)

func take_damage(damageTaken: int) -> void:
	if !isHit:
		# Play damage animation
		# Turn movement off
		isHit = true
		# Take damage
		health -= damageTaken
		# Start timer to not take damage again
		$HitTimer.start()
		$MovementPauseTimer.start()
		$AnimationPlayer.play("TakeDamage")
		 # Turn off collision so we don't hit things until after the hit timer expires
		set_collision(1, false)


func _on_HitTimer_timeout() -> void:
	# Turn collision back on
	set_collision(1, true)


func _on_MovementPauseTimer_timeout() -> void:
	# Turn movement back on
	isHit = false

func set_collision(bit: int, state: bool) -> void:
	set_collision_mask_bit(bit, state)

func _on_Timer_timeout() -> void:
	if $Footsteps/Timer.wait_time != 0.4:
		$Footsteps/Timer.wait_time = 0.4
	$Footsteps/Sound.pitch_scale = rand_range(0.7, 1.3)
	$Footsteps/Sound.play()
