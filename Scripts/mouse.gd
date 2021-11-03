extends KinematicBody2D

# The mouse, once placed on a surface, will patrol the top of that surface until
# it sees an enemy. Then, it will chase that enemy, and attempt to attack!

# Constants
var target : Vector2

# Attacking constants
onready var attackDistance : float = 50
export(float, 0, 100) var health : float = 10 

# Moving constants
export(int, 0, 500) var speed : float = 100
var direction : Vector2
var velocity : Vector2
export(float, 0, 1000) var gravity : float = 98

func _ready() -> void:
	randomize()
	var randDir = randi() % 2
	if randDir:
		direction.x = -1
		$Sprite.flip_h = false
	else:
		direction.x = 1
		$Sprite.flip_h = true

func _physics_process(delta: float) -> void:
	patrol()
	if !is_on_floor():
		velocity.y += gravity
	else:
		velocity.y = 0
	
	move_and_slide(velocity, Vector2.UP)

func patrol():
	if !$FloorCheckLeft.is_colliding():
		direction.x = 1
		$Sprite.flip_h = true
	if !$FloorCheckRight.is_colliding():
		direction.x = -1
		$Sprite.flip_h = false
	
	velocity = direction * speed
