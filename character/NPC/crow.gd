extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = Vector2(0,0)
var is_flying = false
var is_taking_off = false
var take_off_rate = -.1
var take_off_direction = .2
var is_dead = false

func _ready() -> void:
	$spr_crow.scale.x = [-1, 1].pick_random()
	randomize_peck()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_taking_off:
		take_off_rate += -.02
		take_off_rate = clamp(take_off_rate, -3, -.001)
		direction.y = take_off_rate
		direction.x = take_off_direction
	if direction:
		velocity = direction * SPEED
	move_and_slide()

func randomize_peck():
	$tmr_peck.wait_time = randf_range(.5, 5)
	$tmr_peck.start()

func _on_tmr_peck_timeout() -> void:
	if(!is_flying):
		$AnimationPlayer.play("peck")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "peck"):
		if(!is_flying):
			$AnimationPlayer.play("idle")
			randomize_peck()
			$spr_crow.scale.x = [-1, 1].pick_random()
		
func _on_ara_lift_off_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("lift_off")
	$AnimationPlayer.speed_scale = 2.0
	is_flying = true
	is_taking_off = true
	direction.y = take_off_rate
	direction.x = [-1, 1].pick_random()/5
	$AudioStreamPlayer.play()
	$tmr_queue_free.start()

func take_damage(_damage):
	global_collisions.set_enemy_dead_walls(self)
	$ara_lift_off/cls_lift_off.set_deferred("disabled",  true)
	is_dead = true
	$spr_crow.visible = false
	$feathers.emitting = true
	$blood.play_blood()
	$tmr_queue_free.start()
	return 0

func _on_tmr_queue_free_timeout() -> void:
	queue_free()
