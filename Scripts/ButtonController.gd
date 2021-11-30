extends Area2D

onready var lock = get_parent()
signal button_pressed

func _on_Button_body_entered(body):
	if body.is_in_group("Player"):
		lock.queue_free()
