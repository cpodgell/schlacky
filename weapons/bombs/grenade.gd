extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$explosion.emitting = false
	$tmr_fuse.start()
	var mat = PhysicsMaterial.new()
	mat.friction = 500    # higher = stops sliding
	mat.bounce = .3      # lower = less bounce (0 = no bounce)
	angular_damp = 6.0
	physics_material_override = mat
	pass # Replace with function body

func _on_tmr_fuse_timeout() -> void:
	$spr_grenade.visible = false
	$explosion.restart()
	$explosion.one_shot = true
	$explosion.emitting = true
	$ara_dmg/cls_dmg.disabled = false
	$tmr_dmg.start()
	$asp_explosion.play()

func _on_tmr_dmg_timeout() -> void:
	$ara_dmg/cls_dmg.disabled = true
	$tmr_queue_free.start()

func _on_tmr_queue_free_timeout() -> void:
	queue_free()

func _on_ara_dmg_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		body.take_damage(4)
