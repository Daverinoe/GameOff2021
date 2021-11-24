extends Control


func _on_ExitButton_pressed():
	call_deferred("queue_free")
