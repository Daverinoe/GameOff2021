extends Node2D

signal levelChanged(levelName)

export (String) var levelName = "level"

onready var spawnPoint = get_node("Spawn")
onready var player = get_tree().get_nodes_in_group("Player")[0]
onready var tileMap = get_node("TileMap").get_used_rect()
onready var tileSize = get_node("TileMap").cell_size

var cameraLimit = [-10000000, -10000000, 10000000, 10000000]

var levelParam := {
	
}

func _ready() -> void:
	cameraLimit[0] = tileMap.position.x * tileSize.x
	cameraLimit[1] = tileMap.position.y * tileSize.y
	cameraLimit[2] = tileMap.end.x * tileSize.x
	cameraLimit[3] = tileMap.end.y * tileSize.y
	
func cleanup():
	queue_free()

func loadLevelParam(newLevelParam: Dictionary):
	levelParam = newLevelParam

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.isChangingLevel = true
		emit_signal("levelChanged", levelName)
