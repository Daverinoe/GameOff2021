extends Area2D

signal button_pressed

func _on_Button_body_entered(body):
	if body.is_in_group("Player"):
		print(str('Player has entered'))
		emit_signal("button_pressed")
