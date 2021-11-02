extends KinematicBody2D

# Expose these variables to the inspector
export(int, 0, 1000) var maxSpeed : int = 1000
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
var jumping : bool = false
var falling : bool = false

func _process(delta: float) -> void:
	# Get the input here so that we don't miss any inputs due to the set update of _physics_process
	get_input_and_set_direction()
	get_input_and_set_jump()


func _physics_process(delta: float) -> void:
	set_velocity()
	check_floor() # Check floor after moving, otherwise we can never leave the floor again
	move_and_slide(velocity, Vector2.UP)


func get_input_and_set_direction() -> void:
	if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
		direction.x = 0
	elif Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1
	else:
		direction.x = 0

func get_input_and_set_jump() -> void:
	if Input.is_action_just_pressed("jump") and !jumping:
		velocity.y = 0 # Do a velocity check here so velocity change later is instantaneous
		jumping = true
	if Input.is_action_just_released("jump") and jumping:
		falling = true

func set_velocity() -> void:
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
	
	# Down movement (gravity)
	if !is_on_floor() and velocity.y <= terminalVelocity:
		velocity.y += gravity

func check_floor():
	if is_on_floor() and falling:
		falling = false
		jumping = false
