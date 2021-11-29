extends Node

var nextLevel = null
var exit = null
var gameOverBool = false

onready var currentLevel = $Office/Level #This is the start level
onready var anim = $AnimationPlayer
onready var player = $character
onready var camera = $character/Camera2D
onready var levelDataClass = load("res://Scripts/levelData.gd")
onready var levelData = levelDataClass.new()

var score = 0


func _ready() -> void:
	currentLevel.connect("levelChanged", self, "handleLevelChanged")
	setCameraLimits()


func handleLevelChanged(currentLevelName: String, exitTemp: int):
	var nextLevelName: String
	var nextLevelNameTemp = levelData.levelConnect.get(currentLevelName)
	exit = exitTemp
	nextLevelName = nextLevelNameTemp[exit]
			
	nextLevel = load("res://Scenes/VrForest/" + nextLevelName + ".tscn").instance()
	nextLevel.visible = false
	checkData(nextLevel, nextLevelName)
	changeData(currentLevel, currentLevelName)
	call_deferred("add_child", nextLevel)
	anim.play("fadeIn")
	nextLevel.connect("levelChanged", self, "handleLevelChanged")
	transferDataBetweenScenes(currentLevel, nextLevel)

func checkData(var level, var levelName):
	var x = 0
	var y = 0
	var openDoors = levelData.openDoors.get(levelName)
	var pointsTaken = levelData.pointsTaken.get(levelName)
	
	for child in level.get_children():
		if child.is_in_group("Door"):
			if(openDoors[x]):
				child.setOpen()
			x += 1
		elif child.is_in_group("Computer"):
			if(pointsTaken[y]):
				child.setActive()
			y += 1 

func changeData(var level, var levelName):
	var x = 0
	var y = 0
	var openDoors = levelData.openDoors.get(levelName)
	var pointsTaken = levelData.pointsTaken.get(levelName)
	
	for child in level.get_children():
		if child.is_in_group("Door"):
			if child.collisionDisabled():
				openDoors[x] = true
			x += 1
		elif child.is_in_group("Computer"):
			if !child.computerActive():
				pointsTaken[y] = true
			y += 1

func transferDataBetweenScenes(oldScene, newScene):
	newScene.loadLevelParam(oldScene.levelParam)


func setCameraLimits():
	camera.limit_left = currentLevel.cameraLimit[0]
	camera.limit_top = currentLevel.cameraLimit[1]
	camera.limit_right = currentLevel.cameraLimit[2]
	camera.limit_bottom = currentLevel.cameraLimit[3]
	
func gameOver():
	gameOverBool = true
	player.isChangingLevel = true
	anim.play("fadeIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fadeIn":
			if gameOverBool:
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
