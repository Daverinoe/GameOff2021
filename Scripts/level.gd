extends Node2D

signal levelChanged(levelName)

export (String) var levelName = "level"

onready var player = get_tree().get_nodes_in_group("Player")[0]

onready var tileMap = get_node("TileMap").get_used_rect()
onready var tileSize = get_node("TileMap").cell_size

var cameraLimit = [-10000000, -10000000, 10000000, 10000000]
var spawnPoint = null

var levelParam := {
	
}

func _ready() -> void:
	cameraLimit[0] = tileMap.position.x * tileSize.x
	cameraLimit[1] = tileMap.position.y * tileSize.y
	cameraLimit[2] = tileMap.end.x * tileSize.x
	cameraLimit[3] = tileMap.end.y * tileSize.y
	
func cleanup():
	call_deferred("queue_free")

func getSpawn(spawnId : int) -> Node2D:
	match spawnId:
		0:
			spawnPoint = get_node("SpawnLeft")
		1: 
			spawnPoint = get_node("SpawnRight")
		2: 
			spawnPoint = get_node("SpawnTop")
		3:
			spawnPoint = get_node("SpawnBottom")
	return spawnPoint

func loadLevelParam(newLevelParam: Dictionary):
	levelParam = newLevelParam

func _on_ExitLeft_body_entered(body):
	changeLevelCheck(body, 0)

func _on_ExitRight_body_entered(body):
	changeLevelCheck(body, 1)

func _on_ExitTop_body_entered(body):
	changeLevelCheck(body, 2)
	
func _on_ExitBottom_body_entered(body):
	changeLevelCheck(body, 3)

func changeLevelCheck(body, exit : int):
	if body.is_in_group("Player"):
		body.isChangingLevel = true
		emit_signal("levelChanged", levelName, exit)


func _on_Level_visibility_changed():
	if is_visible():
		for exit in get_tree().get_nodes_in_group("Exits"):
			exit.set_monitoring(true) 


func _on_ExitExit_body_entered(body):
	changeLevelCheck(body, 4)
