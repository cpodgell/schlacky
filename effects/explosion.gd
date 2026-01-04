class_name Explosion extends GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_explosion():
	restart()
	emitting = true
	$tmr_queue_free.start()

func _on_tmr_queue_free_timeout() -> void:
	call_deferred("queue_free")
