extends Node


onready var currentLevel = $Office/Level


func _ready() -> void:
	currentLevel.connect("levelChanged", self, "handleLevelChanged")

func handleLevelChanged(currentLevelName: String):
	var nextLevel
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
	nextLevel.connect("levelChanged", self, "handleLevelChanged")
	currentLevel.queue_free()
	currentLevel = nextLevel

	
