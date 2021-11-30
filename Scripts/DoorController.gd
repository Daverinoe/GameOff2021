extends StaticBody2D

onready var collisionShape = get_node("CollisionShape2D")
onready var anim = get_node("AnimationPlayer")

var animPlayed = false

func _process(_delta):
	var open = checkLocks()
	if(open):
		collisionShape.disabled = true
		if not animPlayed:
			anim.play("open")
			animPlayed = true
	elif(!open and collisionShape.disabled):
		collisionShape.disabled = false
		anim.play("close")
		animPlayed = false
			
func checkLocks() -> bool:
	for child in self.get_children():
		if(child.is_in_group("Lock")):
			return false
	return true
	
func setOpen():
	for child in self.get_children():
		if(child.is_in_group("Lock")):
			child.queue_free()

func collisionDisabled():
	return collisionShape.disabled
