extends Node2D

signal levelChanged(levelName)

export (String) var levelName = "level"

onready var spawnPoint = get_node("Spawn")
onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	player.position = spawnPoint.position

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("levelChanged", levelName)
