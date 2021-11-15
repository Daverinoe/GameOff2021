extends Node

var nextLevel = null

onready var currentLevel = $Office/Level #This is the start level
onready var anim = $AnimationPlayer
onready var player = $character
onready var camera = $character/Camera2D


func _ready() -> void:
	currentLevel.connect("levelChanged", self, "handleLevelChanged")
	setCameraLimits()
	
func _process(delta):
	pass

func handleLevelChanged(currentLevelName: String):
	var nextLevelName: String

	match currentLevelName:
		"officeHub":
			nextLevelName = "Office/officeOne"
		"officeOne":
			nextLevelName = "Office/officeHub"
		_:
			return
			
	nextLevel = load("res://Scenes/" + nextLevelName + ".tscn").instance()
	nextLevel.visible = false
	add_child(nextLevel)
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

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fadeIn":
			currentLevel.cleanup()
			currentLevel = nextLevel
			currentLevel.visible = true
			nextLevel = null
			player.position = currentLevel.spawnPoint.position
			setCameraLimits()
			anim.play("fadeOut")
		"fadeOut":
			player.isChangingLevel = false
