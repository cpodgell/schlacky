class_name Casing extends RigidBody2D

var rotation_rate = 0.0

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	linear_damp = 2.0 
	$Timer.start()
	pass
	
	# You can also stop any manual rotation control here since physics takes over
	# No need to manually update the rotation anymore in _process

func set_type(_number):
	if(_number <= $Sprite2D.hframes):
		$Sprite2D.frame = _number

func play(_direction = Vector2.ZERO):
	# Set the initial angular velocity
	rotation_rate = randf_range(0.1, 0.4)  # Random initial spin speed
	angular_velocity = rotation_rate  # Apply this to the rigidbody's angular velocity
	
	# Optionally, point the rigid body in the desired direction initially
	# Example: Pointing it towards a target direction (use vector normalization)
	_direction = Vector2(1, 0)  # Example direction; replace as needed
	look_at(_direction)


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("shrink")
	freeze = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
