extends StaticBody2D

onready var collisionShape = get_node("CollisionShape2D")

func _process(_delta):
	var open = checkLocks()
	if(open):
		collisionShape.disabled = true
	elif(!open and collisionShape.disabled):
		collisionShape.disabled = false
			
func checkLocks() -> bool:
	for child in self.get_children():
		if(child.is_in_group("Lock")):
			return false
	return true
