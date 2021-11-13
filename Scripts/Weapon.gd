extends Node2D

export(int, 1, 3) var damage : int = 1

export(PackedScene) var shot : PackedScene

var shotNum : int = 0
onready var sentenceNum : int = randi() % 4

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		$shotTimer.wait_time = 0.05
		$shotTimer.start()
	if Input.is_action_just_released("shoot"):
		$shotTimer.stop()


func _on_shotTimer_timeout() -> void:
	if $shotTimer.wait_time != 0.2:
		$shotTimer.wait_time = 0.2
	var shooter = shot.instance()
	shooter.position = global_position
	shooter.direction = get_parent().direction
	shooter.damage = damage
	shooter.letterNum = shotNum
	shooter.sentenceNum = sentenceNum
	shooter.speed = shooter.speed + abs(get_parent().velocity.x)
	shooter.connect("sentenceFinished", self, "_choose_random_sentence", [shooter])
	owner.owner.add_child(shooter)
	shotNum += 1

func _choose_random_sentence(scene) -> void:
	sentenceNum = randi() % scene.sentences.size()
	shotNum = 0