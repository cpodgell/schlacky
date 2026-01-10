class_name Pistol extends Node2D

@export var weapon_type: GameDefs.WeaponType = GameDefs.WeaponType.NONE

@export var starting_guns: Array[GameDefs.WeaponType] = [
	GameDefs.WeaponType.PISTOL
]

var clip_by_weapon: Dictionary = {}


var guns_in_inventory: Array[GameDefs.WeaponType] = []


var casing_scene = preload("res://effects/casing.tscn")
@export var laser_scene: PackedScene = preload("res://weapons/bullets/laser.tscn")

var gun_index: int = 0

var is_reloading = false
var is_firing = false
var fire_button_down = false

var shots_before_reload = 1
var shots_counter = 0

var rounds_in_clip : int = 0
var max_rounds_in_clip : int = 0

var cycle_fire = false

var bullet_scene = preload("res://weapons/bullets/bullet.tscn")
var gun_owner : Player
var shot_count = 0

var current_case_type = 0

@onready var pistol = $gun_sprites/spr_gun
@onready var shotgun = $gun_sprites/spr_shot_gun
@onready var machine_gun = $gun_sprites/spr_machine_gun
@onready var uzi = $gun_sprites/spr_uzi
@onready var laser_gun = $gun_sprites/spr_laser
@onready var rocket_gun = $gun_sprites/spr_rocket_launcher

var pistol_clip_max = GameDefs.get_clip_size(GameDefs.WeaponType.PISTOL)
var shotgun_clip_max = GameDefs.get_clip_size(GameDefs.WeaponType.SHOTGUN)
var machine_gun_clip_max = GameDefs.get_clip_size(GameDefs.WeaponType.MACHINE_GUN)
var uzi_clip_max = GameDefs.get_clip_size(GameDefs.WeaponType.UZI)
var laser_clip_max = GameDefs.get_clip_size(GameDefs.WeaponType.LASER)
var rocket_clip_max = GameDefs.get_clip_size(GameDefs.WeaponType.ROCKET_LAUNCHER)

var bullets_total_max = GameDefs.get_total_size(GameDefs.AmmoType.BULLETS)
var shotgun_total_max = GameDefs.get_total_size(GameDefs.AmmoType.SHOTGUN)
var energy_total_max = GameDefs.get_total_size(GameDefs.AmmoType.ENERGY)
var explosive_total_max = GameDefs.get_total_size(GameDefs.AmmoType.EXPLOSIVE)

var bullets_total = bullets_total_max
var shotgun_total = shotgun_total_max
var energy_total = energy_total_max
var explosive_total = explosive_total_max

var bullet_type: GameDefs.AmmoType = GameDefs.AmmoType.BULLETS

func _ready() -> void:
	gun_index = 0
	guns_in_inventory = starting_guns.duplicate()

	if guns_in_inventory.is_empty():
		weapon_type = GameDefs.WeaponType.NONE
		reset_gun()
		return

	weapon_type = guns_in_inventory[0]

	# Starting guns start LOADED (full clip)
	for w in guns_in_inventory:
		_set_clip_for_weapon(w, _get_clip_max_for_weapon(w))

	# Force load the currently equipped weapon from the dict
	max_rounds_in_clip = _get_clip_max_for_weapon(weapon_type)
	rounds_in_clip = _get_clip_for_weapon(weapon_type)

	reset_gun()
	_set_clip_for_weapon(weapon_type, _get_clip_max_for_weapon(weapon_type))
	rounds_in_clip = _get_clip_for_weapon(weapon_type)

	# total ammo includes clip: subtract the loaded clip from the correct reserve pool
	var ammo_type = GameDefs.get_ammo_type(weapon_type)
	match ammo_type:
		GameDefs.AmmoType.BULLETS:
			bullets_total -= rounds_in_clip
		GameDefs.AmmoType.SHOTGUN:
			shotgun_total -= rounds_in_clip
		GameDefs.AmmoType.ENERGY:
			energy_total -= rounds_in_clip
		GameDefs.AmmoType.EXPLOSIVE:
			explosive_total -= rounds_in_clip

	# safety: never allow negative reserve
	bullets_total = max(bullets_total, 0)
	shotgun_total = max(shotgun_total, 0)
	energy_total = max(energy_total, 0)
	explosive_total = max(explosive_total, 0)

	update_hud(max_rounds_in_clip, rounds_in_clip, bullets_total_max, bullets_total)
	print("PISTOL READY clip_by_weapon=", clip_by_weapon, " rounds_in_clip=", rounds_in_clip)






func update_hud(_bullet_max, _bullet_amount, _bullet_total_max, _bullet_total_amount):
	if not (global.main and gun_owner):
		return

	var reserve = _get_reserve_for_current_weapon()
	var reserve_max = reserve[0]
	var reserve_cur = reserve[1]

	global.main.update_hud(
		_bullet_max,
		_bullet_amount,
		reserve_max,
		reserve_cur,
		weapon_type,
		gun_owner.player_number
	)

	
func cycle_gun() -> void:
	if guns_in_inventory.is_empty():
		return
	if guns_in_inventory.size() == 1:
		weapon_type = guns_in_inventory[0]
		reset_gun()
		return

	gun_index = (gun_index + 1) % guns_in_inventory.size()
	weapon_type = guns_in_inventory[gun_index]
	reset_gun()
	sound_manager.play_gun_cycle()

func _get_clip_max_for_weapon(w: GameDefs.WeaponType) -> int:
	return GameDefs.get_clip_size(w)

func _get_clip_for_weapon(w: GameDefs.WeaponType) -> int:
	if clip_by_weapon.has(w):
		return int(clip_by_weapon[w])
	# first time ever holding this gun: start EMPTY
	return 0


func _set_clip_for_weapon(w: GameDefs.WeaponType, amount: int) -> void:
	var m = _get_clip_max_for_weapon(w)
	clip_by_weapon[w] = clamp(amount, 0, m)


func reset_gun():
	cycle_fire = false
	current_case_type = 1
	for c in $gun_sprites.get_children():
		if c is Sprite2D:
			c.visible = false
	match weapon_type:
		GameDefs.WeaponType.PISTOL:
			pistol.visible = true
			max_rounds_in_clip = pistol_clip_max
			rounds_in_clip = _get_clip_for_weapon(weapon_type)
			$tmr_shot_delay.wait_time = .2
		GameDefs.WeaponType.SHOTGUN:
			$tmr_shot_delay.wait_time = .7
			max_rounds_in_clip = shotgun_clip_max
			rounds_in_clip = _get_clip_for_weapon(weapon_type)
			shotgun.visible = true
			current_case_type = 0
		GameDefs.WeaponType.MACHINE_GUN:
			cycle_fire = true
			machine_gun.visible = true
			max_rounds_in_clip = machine_gun_clip_max
			rounds_in_clip = _get_clip_for_weapon(weapon_type)
			$tmr_shot_delay.wait_time = .1
		GameDefs.WeaponType.UZI:
			cycle_fire = true
			uzi.visible = true
			max_rounds_in_clip = uzi_clip_max
			rounds_in_clip = _get_clip_for_weapon(weapon_type)
			$tmr_shot_delay.wait_time = .04
		GameDefs.WeaponType.LASER:
			cycle_fire = true
			laser_gun.visible = true
			max_rounds_in_clip = laser_clip_max
			rounds_in_clip = _get_clip_for_weapon(weapon_type)
			$tmr_shot_delay.wait_time = .1
		GameDefs.WeaponType.ROCKET_LAUNCHER:
			cycle_fire = false
			rocket_gun.visible = true
			max_rounds_in_clip = rocket_clip_max
			rounds_in_clip = _get_clip_for_weapon(weapon_type)
			$tmr_shot_delay.wait_time = 2
			current_case_type = 2
	update_hud(max_rounds_in_clip,rounds_in_clip, bullets_total_max, bullets_total)

func fire_down():
	fire_button_down = true
	if !is_firing and !is_reloading and weapon_type != GameDefs.WeaponType.NONE:
		_fire()

func fire_up():
	fire_button_down = false

func set_pistol_owner(_owner: Player) -> void:
	print("SET OWNER clip_by_weapon=", clip_by_weapon, " rounds_in_clip=", rounds_in_clip)
	gun_owner = _owner
	update_hud(max_rounds_in_clip,rounds_in_clip, bullets_total_max, bullets_total)

func _fire():
	if(rounds_in_clip <= 0):
		sound_manager.play_dry_fire()
		return
	rounds_in_clip -= 1
	_set_clip_for_weapon(weapon_type, rounds_in_clip)
	update_hud(max_rounds_in_clip,rounds_in_clip, bullets_total_max, bullets_total)
	is_firing = true
	release_casing()
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("gun_shot")
	if(weapon_type == GameDefs.WeaponType.SHOTGUN):
		$tmr_reload_sound.start()
		$tmr_shot_delay.start()
		for i in 12:
			var spread = randf_range(-.15, .15)
			var speed = randf_range(390, 550)
			spawn_bullet(Vector2(0,spread), speed, .3)
			sound_manager.play_shotgun()
	if(weapon_type == GameDefs.WeaponType.PISTOL):
		var speed = 500
		$tmr_shot_delay.start()
		sound_manager.play_pistol()
		spawn_bullet(Vector2.ZERO, speed)
	if(weapon_type == GameDefs.WeaponType.MACHINE_GUN):
		var speed = 600
		$tmr_shot_delay.start()
		sound_manager.play_pistol()
		spawn_bullet(Vector2.ZERO, speed)
	if(weapon_type == GameDefs.WeaponType.UZI):
		var speed = 800
		$tmr_shot_delay.start()
		sound_manager.play_uzi()
		$gun_sprites.rotation = randf_range(-.4,.4)
		spawn_bullet(Vector2.ZERO, speed)
	if(weapon_type == GameDefs.WeaponType.LASER):
		$tmr_shot_delay.start()
		sound_manager.play_uzi()
		$gun_sprites.rotation = randf_range(-.1,.1)
		spawn_laser()
	if(weapon_type == GameDefs.WeaponType.ROCKET_LAUNCHER):
		var speed = 400
		$tmr_shot_delay.start()
		sound_manager.play_rocket()
		var bullet : Bullet = spawn_bullet(Vector2.ZERO, speed)
		bullet.add_ordnance()
		bullet.bullet_type = bullet.BulletType.ROCKET
		bullet._apply_bullet_visuals()

func spawn_laser() -> void:
	var laser: LaserBeam = laser_scene.instantiate()
	# Spawn at the gun's position
	laser.global_position = $mkr_fire_position.global_position
	laser.bullet_owner = gun_owner
	# Shoot straight right (local +X)
	laser.direction = Vector2(get_parent().scale.x, 0)
	# Optional tuning (safe defaults)
	laser.damage = 20
	laser.owner = self
	# Add to scee (NOT as a child of the gun)
	get_tree().current_scene.add_child(laser)
	laser.fire()

func spawn_bullet(_direction = Vector2.ZERO, _speed : float = 0,  _time_till_death : float = 0):
	var bullet : Bullet = bullet_scene.instantiate()
	bullet.bullet_type = Bullet.BulletType.FLAT
	global_collisions.set_player_bullet(bullet)
	global.current_level.add_to_ysort(bullet)
	var x = get_parent().scale.x
	bullet.bullet_owner = gun_owner
	
	if(_direction.y == 0):
		var direction_new = Vector2(x, sin($gun_sprites.rotation))
		bullet.direction = direction_new
	else:
		bullet.direction = Vector2(x,_direction.y)
	bullet.rotation = get_parent().scale.x * $gun_sprites.rotation
	bullet.set_death(_time_till_death)
	if(_speed != 0):
		bullet.speed = _speed
	bullet.global_position = $mkr_fire_position.global_position
	return bullet

func reload():
	if weapon_type == GameDefs.WeaponType.NONE:
		return
	if is_reloading:
		return

	# already full?
	if rounds_in_clip >= max_rounds_in_clip:
		return

	# no reserve ammo?
	var ammo_type = GameDefs.get_ammo_type(weapon_type)
	if _get_reserve_amount(ammo_type) <= 0:
		return

	is_reloading = true
	$AnimationPlayer.play("reload")


func play_reload_sound():
	sound_manager.play_reload2()

func release_casing():
	var case : Casing = casing_scene.instantiate()
	global.current_level.add_to_ysort(case)
	case.global_position = global_position
	case.linear_velocity = Vector2.ZERO
	case.set_type(current_case_type)
	var x = get_parent().scale.x * -1
	x = randf_range(x*20, x*40)
	var y = randf_range(-300, -100)
	#case.apply_impulse(Vector2(x, randf_range(-300,-200)), Vector2(0, 0))  # Stronger upward impulse
	#case.apply_impulse(Vector2(randf_range(-200, -100), -300), Vector2(0, 0))  # Random backward and upward impulse with spin
	case.apply_impulse(Vector2(x,y), Vector2(0, 0))
	case.angular_velocity = randf_range(5, 20)

	case.visible = true
	# Increment shot count to cycle through the casings
	shot_count += 1

func _get_reserve_amount(ammo_type: GameDefs.AmmoType) -> int:
	match ammo_type:
		GameDefs.AmmoType.BULLETS: return bullets_total
		GameDefs.AmmoType.SHOTGUN: return shotgun_total
		GameDefs.AmmoType.ENERGY: return energy_total
		GameDefs.AmmoType.EXPLOSIVE: return explosive_total
		_: return 0

func _set_reserve_amount(ammo_type: GameDefs.AmmoType, value: int) -> void:
	value = max(value, 0)
	match ammo_type:
		GameDefs.AmmoType.BULLETS: bullets_total = value
		GameDefs.AmmoType.SHOTGUN: shotgun_total = value
		GameDefs.AmmoType.ENERGY: energy_total = value
		GameDefs.AmmoType.EXPLOSIVE: explosive_total = value

func _get_reserve_max(ammo_type: GameDefs.AmmoType) -> int:
	match ammo_type:
		GameDefs.AmmoType.BULLETS: return bullets_total_max
		GameDefs.AmmoType.SHOTGUN: return shotgun_total_max
		GameDefs.AmmoType.ENERGY: return energy_total_max
		GameDefs.AmmoType.EXPLOSIVE: return explosive_total_max
		_: return 0

func _get_reserve_for_current_weapon() -> Array:
	var ammo_type = GameDefs.get_ammo_type(weapon_type)
	return [_get_reserve_max(ammo_type), _get_reserve_amount(ammo_type)]


func _apply_reload_from_reserve() -> void:
	if weapon_type == GameDefs.WeaponType.NONE:
		return

	# how much we need to fill the clip
	var needed = max_rounds_in_clip - rounds_in_clip
	if needed <= 0:
		return

	var ammo_type = GameDefs.get_ammo_type(weapon_type)
	var reserve = _get_reserve_amount(ammo_type)
	if reserve <= 0:
		return

	var take = int(min(needed, reserve))

	rounds_in_clip += take
	_set_clip_for_weapon(weapon_type, rounds_in_clip) # <-- YES, right here
	_set_reserve_amount(ammo_type, reserve - take)

	update_hud(max_rounds_in_clip,rounds_in_clip, bullets_total_max, bullets_total)


func add_gun(gun) -> bool:
	if gun == GameDefs.WeaponType.NONE:
		return false
	if gun in guns_in_inventory:
		return false

	guns_in_inventory.append(gun)

	# DON'T overwrite existing clip state if we already have one saved
	# If it's truly a brand-new gun, choose a default:
	if not clip_by_weapon.has(gun):
		# OPTION A: start empty (no free reload)
		# _set_clip_for_weapon(gun, 0)

		# OPTION B: start full (arcade pickup)
		_set_clip_for_weapon(gun, _get_clip_max_for_weapon(gun))

	if guns_in_inventory.size() == 3:
		remove_gun(weapon_type)

	return true



func remove_gun(gun: GameDefs.WeaponType) -> void:
	if not (gun in guns_in_inventory):
		return

	var removing_current = (weapon_type == gun)
	guns_in_inventory.erase(gun)

	if guns_in_inventory.is_empty():
		weapon_type = GameDefs.WeaponType.NONE
		return

	if removing_current:
		gun_index = clamp(gun_index, 0, guns_in_inventory.size() - 1)
		weapon_type = guns_in_inventory[gun_index]
		reset_gun()
	else:
		gun_index = clamp(gun_index, 0, guns_in_inventory.size() - 1)

func _on_tmr_shot_delay_timeout() -> void:
	is_firing = false
	$gun_sprites.rotation = 0
	if(fire_button_down):
		fire_down()


func _on_tmr_reload_sound_timeout() -> void:
	sound_manager.play_reload_shotgun()


func _on_tmr_decay_timeout() -> void:
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload":
		is_reloading = false
		_apply_reload_from_reserve()
