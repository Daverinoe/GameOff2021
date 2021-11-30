extends ParallaxBackground

onready var camera = get_node("/root/levelLoader/character/Camera2D")



func _ready():
		set_scroll_offset(camera.get_offset())

