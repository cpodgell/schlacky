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
	for c : GPUParticles2D in $particles.get_children():
		c.emitting = true
		c.one_shot = true

func set_blue():
	for p : GPUParticles2D in $particles.get_children():
		p.process_material.anim_offset_max = .6
		p.process_material.anim_offset_min = .6

func set_brown():
	for p : GPUParticles2D in $particles.get_children():
		p.process_material.anim_offset_max = 0
		p.process_material.anim_offset_min = 0

func _on_timer_timeout() -> void:
	emit_signal("block_debris_finished")
	queue_free()
