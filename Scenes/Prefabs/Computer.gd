extends Area2D

onready var levelLoader = get_node("/root/levelLoader")
onready var animSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D

func _on_Computer_body_entered(body):
	if body.is_in_group("Bullet"):
		levelLoader.score += 1
		animSprite.play("default")
		collisionShape.disabled
