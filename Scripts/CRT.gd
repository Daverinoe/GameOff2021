extends KinematicBody2D

export(int, 0, 200) var speed : int = 100
export(float, 0, 1) var acceleration : float = 0.1

var track_enemy : bool = false
var move_to_last_pos : bool = true
var enemy : Node
var last_pos : Vector2
var velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rotation < PI/2:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true
	
	if track_enemy:
		look_at(enemy.get_global_position())
		
	
	if move_to_last_pos:
		set_velocity(last_pos)
		velocity = move_and_slide(velocity)


func _on_detectionArea_body_entered(body: Node) -> void:
	if body.is_in_group("Friendly"):
		track_enemy = true
		enemy = body


func _on_detectionArea_body_exited(body: Node) -> void:
	if body.is_in_group("Friendly"):
		last_pos = body.get_global_position()
		track_enemy = false
		move_to_last_pos = true

func set_velocity(enemy_position : Vector2) -> void:
	velocity = (enemy_position - position) * speed
