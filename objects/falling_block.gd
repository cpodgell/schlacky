extends RigidBody2D

var rock_smash_01 = preload("res://assets/hits/rock_smashable_hit_impact_01.wav")
var rock_smash_02 = preload("res://assets/hits/rock_smashable_hit_impact_02.wav")
var rock_smash_03 = preload("res://assets/hits/rock_smashable_hit_impact_03.wav")

var rock_smashes = [rock_smash_01, rock_smash_02, rock_smash_03]

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

func take_damage(_damage) -> int:
	$stone_debris.play()
	$spr_block.visible = false
	$AudioStreamPlayer.stream = rock_smashes[randi_range(0, 2)]  # Randomly pick a sound
	$AudioStreamPlayer.play()
	$tmr_cls_disable.start()
	return 1

func _on_stone_debris_block_debris_finished() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
