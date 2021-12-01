extends RichTextLabel

onready var levelLoader = get_node("/root/levelLoader")

func _ready() -> void:
	set_text("0")

func _process(_delta) -> void:
	set_text(String(levelLoader.score))
