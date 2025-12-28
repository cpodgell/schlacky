extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_ricochet():
	restart()
	one_shot = true
	emitting = true
	$Timer.start()


func _on_timer_timeout() -> void:
	call_deferred("queue_free")
