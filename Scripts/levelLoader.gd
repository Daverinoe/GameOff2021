extends Node

var nextLevel = null
var exit = null
var gameOver = false

onready var currentLevel = $Office/Level #This is the start level
onready var anim = $AnimationPlayer
onready var player = $character
onready var camera = $character/Camera2D
onready var levelDataClass = load("res://Scripts/levelData.gd")
onready var levelData = levelDataClass.new()


func _ready() -> void:
	currentLevel.connect("levelChanged", self, "handleLevelChanged")
	setCameraLimits()


func handleLevelChanged(currentLevelName: String, exitTemp: int):
	var nextLevelName: String
	var nextLevelNameTemp = levelData.levelConnect.get(currentLevelName)
	exit = exitTemp
	nextLevelName = nextLevelNameTemp[exit]
			
	nextLevel = load("res://Scenes/" + nextLevelName + ".tscn").instance()
	nextLevel.visible = false
	call_deferred("add_child", nextLevel)
	anim.play("fadeIn")
	nextLevel.connect("levelChanged", self, "handleLevelChanged")
	transferDataBetweenScenes(currentLevel, nextLevel)


func transferDataBetweenScenes(oldScene, newScene):
	newScene.loadLevelParam(oldScene.levelParam)


func setCameraLimits():
	camera.limit_left = currentLevel.cameraLimit[0]
	camera.limit_top = currentLevel.cameraLimit[1]
	camera.limit_right = currentLevel.cameraLimit[2]
	camera.limit_bottom = currentLevel.cameraLimit[3]
	
func gameOver():
	gameOver = true
	player.isChangingLevel = true
	anim.play("fadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fadeIn":
			if gameOver:
				get_tree().change_scene("res://Scenes/mainmenu.tscn")
			else:
				currentLevel.cleanup()
				currentLevel = nextLevel
				player.position = currentLevel.getSpawn(exit).position
				setCameraLimits()
				currentLevel.visible = true
				nextLevel = null
			anim.play("fadeOut")
		"fadeOut":
			player.isChangingLevel = false


func _on_Menu_pressed():
	var options = load("res://Scenes/Options.tscn").instance()
	get_tree().current_scene.add_child(options)
