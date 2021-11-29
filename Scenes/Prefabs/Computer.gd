extends Area2D

onready var levelLoader = get_node("/root/levelLoader")
onready var animSprite = $AnimatedSprite
onready var collisionShape = $CollisionShape2D

func _ready() -> void:
	if !monitoring:
		animSprite.play("default")

func _on_Computer_body_entered(body):
	if body.is_in_group("Bullet") and is_monitoring():
		levelLoader.score += 1
		animSprite.play("default")
		set_deferred("monitoring", false) 

func computerActive():
	return monitoring

func setActive():
	set_deferred("monitoring", false) 
