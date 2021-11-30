extends Node2D

export(int, "Double Jump", "Double Speed", "Double shooting", "Faster shots") var powerUp

func _ready() -> void:
	if powerUp == 0:
		$sprite.texture = load("res://Assets/Sprites/Character/powerup/doublejump.png")
	elif powerUp == 1:
		$sprite.texture = load("res://Assets/Sprites/Character/powerup/gofast.png")
	elif powerUp == 1:
		$sprite.texture = load("res://Assets/Sprites/Character/powerup/shootfast.png")

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Friendly"):
		if body.name == "character":
			if powerUp == 0:
				body.doubleJumpCollected = true
			elif powerUp == 1:
				body.doubleShootSpeedCollected = true
			elif powerUp == 1:
				body.doubleJumpCollected = true
			$AnimationPlayer.play("pickedup")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	call_deferred("queue_free")
