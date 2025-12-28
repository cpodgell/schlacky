# walk.gd
# Only gathers/stores horizontal input (x). DOES NOT MOVE.
extends state

var idle_animation_playing := false
var crouching = false
func _ready() -> void:
	pass

func enter():
	idle_animation_playing = false

func handle_input(event):
	if host_reference.player_disabled:
		return "disabled"

	if event.is_action_pressed(host_reference.player_prefix + global_input_map.ATTACK_1):
		host_reference.attack_1_on()
	if event.is_action_released(host_reference.player_prefix + global_input_map.ATTACK_1):
		host_reference.attack_1_off()

	# Gather horizontal-only input (-1..1) and store it on the host.
	var x := Input.get_joy_axis(host_reference.player_number, JOY_AXIS_LEFT_X)
	if abs(x) <= 0.35:
		x = 0.0
	var y := Input.get_joy_axis(host_reference.player_number, JOY_AXIS_LEFT_Y)

	# --- Y gate settings ---
	var deadzone := 0.35
	var max_angle := deg_to_rad(60.0)

	# Use x that already exists (don't change your X code)
	var v := Vector2(x, y)

	# Default: green area
	y = 0.0
	crouching = false

	# Only consider meaningful stick movement
	if v.length() >= deadzone:
		# Must be DOWN and to the RIGHT (matches your wedge)
		if v.y > 0.0 and v.x >= 0.0:
			# Must be inside the 30° cone around DOWN
			if abs(v.angle_to(Vector2.DOWN)) <= max_angle:
				y = 1.0
				crouching = true


	host_reference.input_x = clamp(x, -1.0, 1.0)
	host_reference.write_x(host_reference.input_x)

	# Transition logic
	if abs(host_reference.input_x) > 0.0:
		host_reference.walk(crouching)
		return "walk"
	else:
		return "idle"

func get_state() -> String:
	return name.to_lower()

func _physics_process(delta: float) -> void:
	# Intentionally empty: this state does not move the player.
	pass
