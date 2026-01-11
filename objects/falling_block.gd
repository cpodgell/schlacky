extends CharacterBody2D

var is_dead = false
# Use a custom gravity variable or the project default
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# 1. Apply gravity to the BUILT-IN velocity property
	# If on floor, keep a tiny bit of gravity so is_on_floor() stays true
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset velocity when hitting the floor to stop falling
		velocity.y = 10 # Small "push" to keep contact with floor

	# 2. move_and_slide() handles the actual movement
	# It uses the 'velocity' variable automatically.
	move_and_slide()

	# 3. Cleanup
	if global_position.y > 3000:
		queue_free()

func take_damage(_damage: int) -> int:
	if !is_dead:
		is_dead = true
		$stone_debris.play()
		$spr_block.visible = false
		$AudioStreamPlayer.pitch_scale = randf_range(0.6, 1.1)
		$AudioStreamPlayer.play()
		$tmr_cls_disable.start() 
	return 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_dead and body.has_method("take_damage"):
		# Set deferred to safely disable collision during physics step
		$CollisionShape2D.set_deferred("disabled", true)
		body.take_damage(1)
		take_damage(1)

func _on_stone_debris_block_debris_finished() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
