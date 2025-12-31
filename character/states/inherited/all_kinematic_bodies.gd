# all_kinematic_bodies.gd
class_name all_kinematic_bodies
extends CharacterBody2D

var sprite_body_container: Node2D
var sprite_body: Sprite2D

var is_dead := false
var is_disabled := false
var inertia := 50.0
var crouching = false
# --- PLATFORMER TUNING (moved from Player) ---
var max_fall_speed = 400
var MAX_SPEED = 220.0
const CROUCH_SPEED_MAX = 110
const WALK_SPEED_MAX = 220.0
const JUMP_VELOCITY = -300.0
const acceleration = 1600.00
const deceleration = 1600.0

# Horizontal input stored by states (walk/idle)
var input_x: float = 0.0
var input_y: float = 0.0

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

# -------------------------------------------------------------
# PLATFORMER HELPERS

func accelerate_horizontal(delta: float) -> void:
	var target_vx = input_x * MAX_SPEED
	if input_x != 0.0:
		velocity.x = move_toward(velocity.x, target_vx, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

func try_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		$asp_jump.play()

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
