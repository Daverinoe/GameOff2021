extends Sprite

export(float, 0.0, 1.0) var chance_to_glitch = 0.001
var glitching : bool = false

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	var check_glitch = randf()
	if check_glitch < chance_to_glitch and not glitching:
		glitching = true
		material.set_shader_param("enabled", true)
		get_parent().get_node("GlitchTimer").start()


func _on_GlitchTimer_timeout() -> void:
	glitching = false
	material.set_shader_param("enabled", false)
