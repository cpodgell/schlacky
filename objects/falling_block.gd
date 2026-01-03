extends RigidBody2D

var is_dead = false

func _ready():
	lock_rotation = true
	angular_velocity = 0
	angular_damp = 1000.0  # High value to stop any rotation quickly

	var material = PhysicsMaterial.new()  
	material.friction = 0.0  
	material.bounce = 0.0  

	self.physics_material_override = material
	gravity_scale = 2

	linear_damp = 10.0  

func _process(delta: float) -> void:
	if global_position.y > 3000:
		queue_free()
		

func take_damage(_damage) -> int:
	if(!is_dead):
		$stone_debris.play()
		$spr_block.visible = false
		$AudioStreamPlayer.pitch_scale = randf_range(.6, 1.1) # Randomly pick a sound
		$AudioStreamPlayer.play()
		$tmr_cls_disable.start()
		is_dead = true
	return 1

func _on_stone_debris_block_debris_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		$CollisionShape2D.set_deferred("disabled", true)
		body.take_damage(1)
		take_damage(1)
