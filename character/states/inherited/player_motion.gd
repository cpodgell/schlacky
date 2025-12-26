class_name player_motion
extends state

@export var max_speed := 100.0        # top speed when stick is fully pushed
@export var acceleration := 2500.0    # px/s^2
@export var deceleration := 3000.0    # px/s^2 (friction when no input)
@export var deadzone := 0.35

var input_x := 0.0  # cached each frame or per input event
var joy_con_number: int = 0   # <-- RESTORED

# --- Analog (left stick X only) ---
func get_analog_x(player_number: int) -> float:
	var x := Input.get_joy_axis(player_number, JOY_AXIS_LEFT_X)
	if abs(x) <= deadzone:
		x = 0.0
	return clamp(x, -1.0, 1.0)


# Returns best horizontal input in [-1..1]
# Keyboard overrides if it's stronger than analog (nice hybrid behavior).
func get_move_x(player_prefix: String, player_number: int) -> float:
	var digital := get_digital_x(player_prefix)
	var analog := (player_number)

	if abs(digital) > abs(analog):
		return digital

	return analog


# Convenience: this matches how you were using "if(input_direction):"
# (In Godot, a Vector2(0,0) is falsey-ish, but floats are not.
# So keep it explicit.)
func has_move_input(x: float) -> bool:
	return abs(x) > 0.0

# Apply acceleration/deceleration to a vx and return the new vx.
# You call this from the HOST player script each physics tick.
func update_vx(current_vx: float, delta: float, player_prefix: String, player_number: int) -> float:
	input_x = get_move_x(player_prefix, player_number)

	var target_vx := input_x * max_speed

	if has_move_input(input_x):
		return move_toward(current_vx, target_vx, acceleration * delta)
	else:
		return move_toward(current_vx, 0.0, deceleration * delta)
