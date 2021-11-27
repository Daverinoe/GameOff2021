extends KinematicBody2D

export(int, 0, 200) var speed : int = 1
export(float, 0, 1) var acceleration : float = 0.1

export(int, 0, 10) var damage : int = 5

var attacking : bool = false
export var track_enemy : bool = false
var move_to_last_pos : bool = false
var enemy : Node
var last_pos : Vector2
var velocity
var in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if rotation < PI/2:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true
	
	if track_enemy and in_range:
		_track_enemy()
		
	
	if move_to_last_pos and not attacking:
		set_velocity(last_pos)
		velocity = move_and_slide(velocity)
	
	if attacking:
		velocity = Vector2(0, 0)
		$Attack/AnimationPlayer.play("attack")


func _on_detectionArea_body_entered(body: Node) -> void:
	if body.is_in_group("Friendly"):
		enemy = body
		track_enemy = true
		if not attacking:
			_track_enemy()
			attacking = true
		in_range = true


func _on_detectionArea_body_exited(body: Node) -> void:
	if body.is_in_group("Friendly"):
		last_pos = body.get_global_position()
		track_enemy = false
		move_to_last_pos = true
		in_range = false

func set_velocity(enemy_position : Vector2) -> void:
	velocity = (enemy_position - position) * speed


func _on_attackPause_timeout() -> void:
	if in_range:
		attacking = true

func _stop_attacking() -> void:
	attacking = false
	if in_range:
		track_enemy = true

func _track_enemy() -> void:
	look_at(enemy.get_global_position())


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		$Attack/attackPause.start()

func _check_hit() -> void:
	var raycaster = $Attack/checkHit
	raycaster.enabled = true
	raycaster.force_raycast_update()
	
	if raycaster.is_colliding():
		var collision = raycaster.get_collider()
		collision.take_damage(damage)
	
	raycaster.enabled = false
