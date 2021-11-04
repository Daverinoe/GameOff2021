extends Area2D

onready var buttonNode : Node = get_node_or_null("Button")

func _ready():
	if buttonNode != null:
		buttonNode.connect("button_pressed", self, "open_signal_received")


func open_signal_received():
	print("open")
