# idle.gd
# Gathers/stores horizontal input (x). DOES NOT MOVE.
extends state

var idle_animation_playing := false

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
	if event.is_action_released(host_reference.player_prefix + global_input_map.RELOAD):
		host_reference.attack_1_off()
		host_reference.reload()

	var x := Input.get_joy_axis(host_reference.player_number, JOY_AXIS_LEFT_X)
	var y := Input.get_joy_axis(host_reference.player_number, JOY_AXIS_LEFT_Y)
	if abs(x) <= 0.35:
		x = 0.0
	if abs(y) <= 0.50:
		y = 0.0
		host_reference.set_crouching(false)
		host_reference.idle()
	else:
		host_reference.set_crouching(true)
		host_reference.idle()


	host_reference.input_x = x
	host_reference.input_y = y
	host_reference.print_x(host_reference.input_x)
	host_reference.print_y(y)

	# Transition logic
	if abs(host_reference.input_x) > 0.0:
		return "walk"

func get_state() -> String:
	return name.to_lower()

func _physics_process(delta: float) -> void:
	# Intentionally empty: idle does not move the player.
	pass
