extends Particles2D

func _ready() -> void:
	$Timer.start()

func _on_Timer_timeout() -> void:
	self.call_deferred("queue_free")
