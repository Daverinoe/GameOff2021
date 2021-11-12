extends Node

var nextLevel = null

onready var currentLevel = $Office/Level
onready var anim = $AnimationPlayer


func _ready() -> void:
	currentLevel.connect("levelChanged", self, "handleLevelChanged")

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
	add_child(nextLevel)
	anim.play("fadeIn")
	nextLevel.visible = false
	
	nextLevel.connect("levelChanged", self, "handleLevelChanged")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fadeIn":
			currentLevel.cleanup()
			currentLevel = nextLevel
			currentLevel.visible = true
			nextLevel = null
			anim.play("fadeOut")
