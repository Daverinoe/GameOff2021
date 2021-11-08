extends Label

export(NodePath) onready var characterNodePath
onready var characterNode : Node = get_node(characterNodePath)

var position : Vector2
var direction : Vector2
var velocity : Vector2
var jumping : bool
var falling : bool
var isOnFloor : bool
var gravity : float
var isMoving : bool

func _process(_delta: float) -> void:
	position = characterNode.position
	direction = characterNode.direction
	velocity = characterNode.velocity
	jumping = characterNode.jumping
	falling = characterNode.falling
	isOnFloor = characterNode.is_on_floor()
	gravity = characterNode.gravity
	isMoving = characterNode.isMoving
	
	text = "Position: " + str(position) \
		+ "\nDirection: " + str(direction) \
		+ "\nVelocity: " + str(velocity) \
		+ "\nJumping: " + str(jumping) \
		+ "\nFalling: " + str(falling) \
		+ "\nOn floor: " + str(isOnFloor) \
		+ "\nGravity: " + str(gravity) \
		+ "\nIs moving: " + str(isMoving)
