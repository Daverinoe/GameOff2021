extends Camera2D

onready var player = get_node("/root/levelLoader/character")

func _process(delta):
	position.x = player.position.x