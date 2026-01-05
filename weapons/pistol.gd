extends Node2D

var casing_scene = preload("res://effects/casing.tscn")
@export var laser_scene: PackedScene = preload("res://weapons/bullets/laser.tscn")

@export var weapon_type : int

enum WeaponType {
	NONE,
	PISTOL,
	SHOTGUN,
	MACHINE_GUN,
	UZI,
	LASER,
	ROCKET_LAUNCHER
}

var is_reloading = false
var is_firing = false
var fire_button_down = false

var shots_before_reload = 1
var shots_counter = 0

var rounds_in_clip : int = 0
var max_rounds_in_clip : int = 0

var cycle_fire = false
var gun_cycle_number = 0

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

var pistol_max = 12
var shotgun_max = 12
var machine_gun_max = 35
var uzi_max = 200
var laser_max = 20
var rocket_max = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_gun()
		
	pass # Replace with function body.

func update_hud(_bullet_max, _bullet_amount):
	if(global.main and gun_owner):
		global.main.update_hud(_bullet_max, _bullet_amount, gun_owner.player_number)
	
func cycle_gun():
	gun_cycle_number += 1
	weapon_type = gun_cycle_number % WeaponType.size()
	reset_gun()
	$asp_gun_cycle.play()

func reset_gun():
	current_case_type = 1
	for c in $gun_sprites.get_children():
		if c is Sprite2D:
			c.visible = false
	match weapon_type:
		WeaponType.PISTOL:
			pistol.visible = true
			rounds_in_clip = pistol_max
			max_rounds_in_clip = pistol_max
			$tmr_shot_delay.wait_time = .2
		WeaponType.SHOTGUN:
			$tmr_shot_delay.wait_time = .7
			rounds_in_clip = shotgun_max
			max_rounds_in_clip = shotgun_max
			shotgun.visible = true
			current_case_type = 0
		WeaponType.MACHINE_GUN:
			cycle_fire = true
			machine_gun.visible = true
			rounds_in_clip = machine_gun_max
			max_rounds_in_clip = machine_gun_max
			$tmr_shot_delay.wait_time = .1
		WeaponType.UZI:
			cycle_fire = true
			uzi.visible = true
			rounds_in_clip = uzi_max
			max_rounds_in_clip = uzi_max
			$tmr_shot_delay.wait_time = .04
		WeaponType.LASER:
			cycle_fire = true
			laser_gun.visible = true
			rounds_in_clip = laser_max
			max_rounds_in_clip = uzi_max
			$tmr_shot_delay.wait_time = .4
		WeaponType.ROCKET_LAUNCHER:
			cycle_fire = false
			rocket_gun.visible = true
			rounds_in_clip = rocket_max
			max_rounds_in_clip = rocket_max
			$tmr_shot_delay.wait_time = 2
			current_case_type = 2
	gun_owner = get_parent().get_parent()
	update_hud(max_rounds_in_clip,rounds_in_clip)

func fire_down():
	fire_button_down = true
	if(!is_firing and !is_reloading):
		_fire()

func fire_up():
	fire_button_down = false

func _fire():
	if(rounds_in_clip <= 0):
		$asp_dry_fire.play()
		return
	rounds_in_clip -= 1
	update_hud(max_rounds_in_clip,rounds_in_clip)
	is_firing = true
	release_casing()
	$AnimationPlayer.stop(true)
	$AnimationPlayer.play("gun_shot")
	if(weapon_type == WeaponType.SHOTGUN):
		$tmr_reload_sound.start()
		$tmr_shot_delay.start()
		for i in 12:
			var spread = randf_range(-.15, .15)
			var speed = randf_range(390, 550)
			spawn_bullet(Vector2(0,spread), speed, .3)
			$asp_shotgun.play()
	if(weapon_type == WeaponType.PISTOL):
		var speed = 500
		$tmr_shot_delay.start()
		$asp_pistol.play()
		spawn_bullet(Vector2.ZERO, speed)
	if(weapon_type == WeaponType.MACHINE_GUN):
		var speed = 600
		$tmr_shot_delay.start()
		$asp_pistol.play()
		spawn_bullet(Vector2.ZERO, speed)
		spawn_bullet(Vector2.ZERO, speed)
	if(weapon_type == WeaponType.UZI):
		var speed = 800
		$tmr_shot_delay.start()
		$asp_uzi.play()
		$gun_sprites.rotation = randf_range(-.4,.4)
		spawn_bullet(Vector2.ZERO, speed)
	if(weapon_type == WeaponType.LASER):
		$tmr_shot_delay.start()
		$asp_uzi.play()
		$gun_sprites.rotation = randf_range(-.1,.1)
		spawn_laser()
	if(weapon_type == WeaponType.ROCKET_LAUNCHER):
		var speed = 400
		$tmr_shot_delay.start()
		$asp_rocket.play()
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
	laser.damage = 2
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
	is_reloading = true
	$AnimationPlayer.play("reload")

func play_reload_sound():
	$asp_reload2.play()

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

	
func _on_tmr_shot_delay_timeout() -> void:
	is_firing = false
	$gun_sprites.rotation = 0
	if(fire_button_down):
		fire_down()


func _on_tmr_reload_sound_timeout() -> void:
	$asp_reload_shotgun.play()


func _on_tmr_decay_timeout() -> void:
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "reload":
		is_reloading = false
		reset_gun()
