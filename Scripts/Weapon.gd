extends Node2D

export(int, 1, 3) var damage : int = 1

export(PackedScene) var shot : PackedScene

export(float, 0.0, 1.0) var shotDelay : float = 0.2

var shotNum : int = 0
onready var sentenceNum : int

func _ready() -> void:
	randomize()
	sentenceNum = randi() % 4

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		$shotTimer.wait_time = 0.05
		$shotTimer.start()
	if Input.is_action_just_released("shoot"):
		$shotTimer.stop()


func _on_shotTimer_timeout() -> void:
	if $shotTimer.wait_time != shotDelay:
		$shotTimer.wait_time = shotDelay
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
	
	$keyClickShot.pitch_scale = rand_range(0.6, 1.0)
	$keyClickShot.play()

func _choose_random_sentence(scene) -> void:
	shotNum = -1
	sentenceNum = randi() % scene.sentences.size()
