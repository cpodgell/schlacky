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
	if event.is_action_released(host_reference.player_prefix + global_input_map.RELOAD):
		host_reference.attack_1_off()
		host_reference.reload()
	if event.is_action_released(host_reference.player_prefix + global_input_map.PICKUP_ITEM):
		host_reference.pickup_item()
	if event.is_action_released(host_reference.player_prefix + global_input_map.SWITCH_GUN_L):
		host_reference.cycle_gun()
	if event.is_action_released(host_reference.player_prefix + global_input_map.SWITCH_GUN_R):
		host_reference.cycle_gun()
	if event.is_action_pressed(host_reference.player_prefix + global_input_map.GRENADE):
		host_reference.prepare_grenade()
	if event.is_action_released(host_reference.player_prefix + global_input_map.GRENADE):
		host_reference.release_grenade()
	# Gather horizontal-only input (-1..1) and store it on the host.
	var x := Input.get_joy_axis(host_reference.player_number, JOY_AXIS_LEFT_X)
	var y := Input.get_joy_axis(host_reference.player_number, JOY_AXIS_LEFT_Y)
	if abs(x) <= 0.35:
		x = 0.0
	if abs(y) <= 0.50:
			y = 0.0
			host_reference.set_crouching(false)
	else:
		host_reference.set_crouching(true)
	host_reference.input_x = x
	host_reference.input_y = y
	host_reference.print_x(host_reference.input_x)
	host_reference.print_y(y)

	# Transition logic
	if abs(host_reference.input_x) > 0.0:
		host_reference.walk()
		return "walk"
	else:
		return "idle"

func get_state() -> String:
	return name.to_lower()

func _physics_process(delta: float) -> void:
	# Intentionally empty: this state does not move the player.
	pass
