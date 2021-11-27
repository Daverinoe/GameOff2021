extends Control

var masterLevel = 0
var SFXLevel = 0
var musicLevel = 0


func _ready() -> void:
	masterLevel = db2linear(AudioServer.get_bus_volume_db(0))
	SFXLevel = db2linear(AudioServer.get_bus_volume_db(1))
	musicLevel = db2linear(AudioServer.get_bus_volume_db(2))

	
	$NinePatchRect/VBoxContainer/HBoxContainer/Column2/VBoxContainer/MasterSound.value = masterLevel
	$NinePatchRect/VBoxContainer/HBoxContainer/Column2/VBoxContainer/SFXSound.value  = SFXLevel
	$NinePatchRect/VBoxContainer/HBoxContainer/Column2/VBoxContainer/MusicSound.value  = musicLevel


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		call_deferred("queue_free")

func _on_ExitButton_pressed():
	call_deferred("queue_free")


func _on_MasterSound_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))


func _on_SFXSound_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))


func _on_MusicSound_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear2db(value))


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
