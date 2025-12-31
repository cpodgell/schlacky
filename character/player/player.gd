# Player.gd
class_name Player
extends all_kinematic_bodies

var current_state = null
var states_map
var player_disabled = false
var player_dead = false
var player_number = 0
var player_prefix = ""
var group_name
var start_position : Vector2 = Vector2.ZERO
var _is_ascending = false
var _is_descending = false
var attack_on = false



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
	reset()

func reset():
	velocity = Vector2.ZERO
	input_x = 0
	input_y = 0
	$health_bar.reset()
	_change_state('idle')
	player_disabled = false
	player_dead = false
	global_position = start_position
	$sb_container.rotation = 0
	global_collisions.set_player(self)

func _physics_process(delta: float) -> void:
	if(player_dead):
		$sb_container.rotation += .3
	
	# --- always apply gravity (platformer baseline) ---
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# --- Determine if the player is ascending or descending ---
	if velocity.y > 0 and not is_descending:  # Player is falling
		is_descending = true
		is_ascending = false  # Stop ascending if descending starts
	
	elif velocity.y < 0 and not is_ascending:  # Player is ascending
		is_ascending = true
		is_descending = false  # Stop descending if ascending starts

	# --- horizontal accel/decel (now handled by base class constants) ---
	accelerate_horizontal(delta)

	# --- state machine update (decides actions / changes state) ---
	if current_state:
		var new_state = current_state.update(delta)
		if new_state:
			_change_state(new_state)

	set_look_direction_manual(velocity)
	if(velocity.y > max_fall_speed):
		velocity.y = max_fall_speed

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

func set_player_color(_color):
	$sb_container/sprite_body.modulate = _color

func reload():
	$sb_container/Pistol.reload()

func cycle_gun():
	$sb_container/Pistol.cycle_gun()

func _input(event):
	if Input.is_key_pressed(KEY_UP):
		take_damage(10)
	# Jump uses base class constant + helper
	if event.is_action_pressed(player_prefix + global_input_map.JUMP) and is_on_floor() and not player_disabled:
		try_jump()


	if current_state:
		var new_state = current_state.handle_input(event)
		if new_state and new_state != current_state.get_state():
			_change_state(new_state)

# Getter and Setter for is_ascending
var is_ascending: bool:
	get:
		return _is_ascending
	set(value):
		if _is_ascending != value:
			_is_ascending = value
			if _is_ascending:
				# treees and platforms, players can go through
				global_collisions.set_mask_bits(self, [global_collisions.PLATFORMS], false)
				# Add any custom logic when ascending starts here
			else:
				global_collisions.set_mask_bits(self, [global_collisions.PLATFORMS], true)
				#print("Player stopped ascending")
				# Add any custom logic when ascending stops here

# Getter and Setter for is_descending
var is_descending: bool:
	get:
		return _is_descending
	set(value):
		if _is_descending != value:
			_is_descending = value
			if _is_descending:
				pass
				#print("Player started descending")
				# Add any custom logic when descending starts here
			else:
				pass
				#print("Player stopped descending")
				# Add any custom logic when descending stops here

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
	$sb_container/Pistol.fire_down()

func attack_1_off():
	$sb_container/Pistol.fire_up()

func set_crouching(_crouching):
	crouching = _crouching
	$cls_player.disabled = crouching
	if(crouching):
		MAX_SPEED = CROUCH_SPEED_MAX
		$sb_container/Pistol.global_position = $mrk_crouch_gun.global_position
	else:
		MAX_SPEED = WALK_SPEED_MAX
		$sb_container/Pistol.global_position = $mrk_stand_gun.global_position

func walk():
	if(crouching):

		$sb_container/sprite_body.play_crouch_walk()
	else:
		MAX_SPEED = WALK_SPEED_MAX
		$sb_container/sprite_body.play_walk()

func idle():
	if(crouching):
		$sb_container/sprite_body.play_crouch_idle()
	else:
		$sb_container/sprite_body.play_idle()

func print_x(_x):
	$lbl_state2.text = str(_x)

func print_y(_y):
	$lbl_state_y.text = str(_y)

func death():
	velocity.y = JUMP_VELOCITY
	$asp_death.play()
	_change_state("dead")
	$tmr_respawn.start()


func add_health(_health):
	$health_bar.add_health(_health)

func take_damage(_damage: int) -> int:
	$asp_damage.play()
	$blood.restart()
	$blood.emitting = true
	$health_bar.add_health(-1 * _damage)
	var health = $health_bar.value
	if health <= 0:
		death()
	return health

func _on_tmr_respawn_timeout() -> void:
	reset()
