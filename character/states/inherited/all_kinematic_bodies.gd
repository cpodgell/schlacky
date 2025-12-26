# all_kinematic_bodies.gd
class_name all_kinematic_bodies
extends CharacterBody2D

var sprite_body_container: Node2D
var sprite_body: Sprite2D

var is_dead := false
var is_disabled := false
var inertia := 50.0

# --- PLATFORMER TUNING (moved from Player) ---
const MAX_SPEED = 220.0
const JUMP_VELOCITY = -300.0
const acceleration = 1600.00
const deceleration = 1600.0

# Horizontal input stored by states (walk/idle)
var input_x: float = 0.0

# --- Look direction ---
var _look_direction := Vector2.ZERO
var _last_look_direction := Vector2.ZERO
var look_direction: Vector2:
	set(value):
		if _look_direction == value:
			return
		_look_direction = value
		if _last_look_direction.x != _look_direction.x:
			_last_look_direction = _look_direction
			set_look_direction_manual(value)
	get:
		return _look_direction

# --- Motion (optional legacy support) ---
var _motion := Vector2.ZERO
var motion: Vector2:
	set(value):
		_motion = value
	get:
		return _motion

# -------------------------------------------------------------
# TOP-DOWN STYLE HELPERS (kept for compatibility)

func apply_friction(amount: float) -> void:
	if _motion.length() > amount:
		_motion -= _motion.normalized() * amount
	else:
		_motion = Vector2.ZERO

func apply_movement(acceleration_vec: Vector2, max_speed: float) -> void:
	_motion += acceleration_vec
	_motion = _motion.limit_length(max_speed)

	# Update facing based on X
	look_direction = Vector2(-1, 0) if _motion.x < 0.0 else Vector2(1, 0)

func apply_external_force(amount: float, direction: Vector2, max_speed: float) -> void:
	_motion += amount * direction.normalized()
	_motion = _motion.limit_length(max_speed)

# -------------------------------------------------------------
# PLATFORMER HELPERS

func accelerate_horizontal(delta: float) -> void:
	var target_vx := input_x * MAX_SPEED
	if input_x != 0.0:
		velocity.x = move_toward(velocity.x, target_vx, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

func try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

# -------------------------------------------------------------

func manual_move_and_slide() -> void:
	velocity = _motion
	move_and_slide()
	_motion = velocity

	# Flip based on actual resulting velocity
	if abs(velocity.x) > 0.01:
		set_look_direction_manual(Vector2(sign(velocity.x), 0))

	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var body := collision.get_collider()
		if body and body.is_in_group("item_base"):
			if body.has_method("apply_impulse"):
				body.apply_impulse(-collision.get_normal() * inertia)

func set_look_direction_manual(direction: Vector2) -> void:
	if direction.x > 0.0:
		if sprite_body_container:
			sprite_body_container.scale.x = 1.0
		look_direction_changed()
	elif direction.x < 0.0:
		if sprite_body_container:
			sprite_body_container.scale.x = -1.0
		look_direction_changed()

func look_direction_changed() -> void:
	pass

func flicker():
	pass
