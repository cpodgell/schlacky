extends Node2D

signal block_debris_finished
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in $particles.get_children():
		c.emitting = false
		c.one_shot = true
	pass # Replace with function body.

func play():
	$Timer.start()
	for c in $particles.get_children():
		c.emitting = true
		c.one_shot = true

func _on_timer_timeout() -> void:
	emit_signal("block_debris_finished")
	queue_free()
