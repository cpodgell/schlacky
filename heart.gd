extends Area2D

@export var max_fall_speed = 800.0

var falling = true
var velocity_y = 0.0  # Initialize this explicitly to 0.0

@onready var ground_ray = $GroundRay

func _process(delta: float) -> void:
	if !falling:
		return

	# accelerate downward
	velocity_y += gravity * delta
	velocity_y = min(velocity_y, max_fall_speed)

	# if ground is directly below, stop falling
	if ground_ray.is_colliding():
		falling = false
		velocity_y = 0.0

		# optional: snap exactly to contact point (prevents hovering)
		var hit_point = ground_ray.get_collision_point()
		# This aligns the Area2D's origin to the hit point; adjust if your origin isn't at the bottom
		global_position.y = hit_point.y
		return

	# otherwise fall
	global_position.y += velocity_y * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("add_health"):
		global_collisions.set_all_layer_bits(self, false)
		global_collisions.set_all_mask_bits(self, false)
		body.add_health(5)
		$Lines.restart()
		$Lines.emitting = true
		$tmr_queue_free.start()
		$spr_heart.visible = false
		$AudioStreamPlayer.play()


func _on_tmr_queue_free_timeout() -> void:
	queue_free()
