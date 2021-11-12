extends KinematicBody2D

var direction : Vector2 = Vector2.RIGHT

export(int, 0, 800) var speed : int = 1600

func _physics_process(delta) -> void:
	var velocity = direction * speed * delta
	var collision = move_and_collide(velocity)
	check_collision()

func check_collision() -> void:
	pass
