# Player.gd
class_name Player
extends all_kinematic_bodies

var current_state = null
var state_name
var states_map
var player_disabled = false
var player_number = 0
var player_prefix = ""
var group_name

func init_states():
	states_map = {
		"idle": $States/Idle,
		"walk": $States/Walk,
		"dead": $States/Dead,
		"disabled": $States/Disabled,
	}

func _ready():
	init_states()
	initialize_states()
	current_state = states_map["idle"]
	current_state.enter()

func _physics_process(delta: float) -> void:
	# --- always apply gravity (platformer baseline) ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- horizontal accel/decel (now handled by base class constants) ---
	accelerate_horizontal(delta)

	# --- state machine update (decides actions / changes state) ---
	if current_state:
		var new_state = current_state.update(delta)
		if new_state:
			_change_state(new_state)

	set_look_direction_manual(velocity)

	# --- always move ---
	move_and_slide()

	update_camera()

func initialize_states():
	current_state = states_map["idle"]
	sprite_body_container = $sb_container
	var children = $States.get_children()
	for i in children.size():
		children[i].host_reference = self
		children[i].sprite_body_reference = sprite_body

func _change_state(state_name):
	if state_name != null:
		$lbl_previous_state.text = "Previous State: " + current_state.get_state()
		current_state.exit()
		current_state = states_map[state_name]
		current_state.enter()
		$lbl_state.text = current_state.get_state()

func _input(event):
	if Input.is_key_pressed(KEY_UP):
		take_damage(10)

	# Jump uses base class constant + helper
	if event.is_action_pressed(player_prefix + global_input_map.JUMP) and is_on_floor() and not player_disabled:
		try_jump()
	if event.is_action_pressed(player_prefix + global_input_map.ACTION) and is_on_floor() and not player_disabled:
		attack_1_on()

	if current_state:
		var new_state = current_state.handle_input(event)
		if new_state and new_state != current_state.get_state():
			_change_state(new_state)

func set_player_number(value):
	player_number = value
	player_prefix = "p" + str(value) + "_"
	group_name = "P" + str(player_number)
	add_to_group(group_name)

func get_look_direction():
	return look_direction

func update_camera():
	pass

func attack_1_on():
	$sb_container/Pistol.fire()

func attack_1_off():
	pass

func walk():
	$sb_container/sprite_body.play_walk()

func idle():
	$sb_container/sprite_body.play_idle()

func write_x(_x):
	$lbl_state2.text = str(_x)

func take_damage(_damage: int) -> int:
	$asp_damage.play()
	$blood.restart()
	$blood.emitting = true
	$health_bar.add_health(-1 * _damage)
	var health = $health_bar.value
	if health < 0:
		_change_state("disabled")
		$pts_blood_splatter.play_effect()
		$Sprite_Body.visible = false
	return health
