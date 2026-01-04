extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$tmr_fuse.start()
	var new_material = PhysicsMaterial.new()
	new_material.friction = 500    # higher = stops sliding
	new_material.bounce = .3      # lower = less bounce (0 = no bounce)
	angular_damp = 6.0
	physics_material_override = new_material
	
	$ara_damager.damage_amount = 4
	$ara_damager.show_explosion = true
	
	pass # Replace with function body

func _on_tmr_fuse_timeout() -> void:
	$spr_grenade.visible = false
	$ara_damager.play_damage()
	$tmr_queue_free.start()

func _on_tmr_queue_free_timeout() -> void:
	queue_free()

func _on_ara_hit_sound_body_entered(body: Node2D) -> void:
	$ara_hit_sound/asp_hit.play()
