extends Node2D

@export var weapon_type : int

enum WeaponType {
	PISTOL,
	SHOTGUN,
	MACHINE_GUN,
	UZI
}

signal reload(time)
var shots_before_reload = 1
var shots_counter = 0
var disabled = false
var rounds_in_clip : int = 0
var cycle_fire = false
var firing = false
var gun_cycle_number = 0

var bullet_scene = preload("res://weapons/bullets/bullet.tscn")
var gun_owner

@onready var pistol = $gun_sprites/spr_gun
@onready var shotgun = $gun_sprites/spr_shot_gun
@onready var machine_gun = $gun_sprites/spr_machine_gun
@onready var uzi = $gun_sprites/spr_uzi


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_gun()
	pass # Replace with function body.

func _input(event):
	if Input.is_key_pressed(KEY_P):
		gun_cycle_number += 1
		weapon_type = gun_cycle_number % WeaponType.size()
		reset_gun()
		$asp_gun_cycle.play()

func reset_gun():
	for c in $gun_sprites.get_children():
		c.visible = false
	match weapon_type:
		WeaponType.PISTOL:
			$casings.process_material.anim_offset_max = 0.5
			$casings.process_material.anim_offset_min = 0.5
			pistol.visible = true
			rounds_in_clip = 6
			$tmr_shot_delay.wait_time = .2
		WeaponType.SHOTGUN:
			$casings.process_material.anim_offset_max = 0.0
			$casings.process_material.anim_offset_min = 0.0
			$tmr_shot_delay.wait_time = .7
			shotgun.visible = true
		WeaponType.MACHINE_GUN:
			cycle_fire = true
			$casings.process_material.anim_offset_max = 0.5
			$casings.process_material.anim_offset_min = 0.5
			machine_gun.visible = true
			rounds_in_clip = 30
			$tmr_shot_delay.wait_time = .1
		WeaponType.UZI:
			cycle_fire = true
			$casings.process_material.anim_offset_max = 0.5
			$casings.process_material.anim_offset_min = 0.5
			uzi.visible = true
			rounds_in_clip = 30
			$tmr_shot_delay.wait_time = .3
	gun_owner = get_parent().get_parent()

func fire_down():
	firing = true
	if(!disabled):
		_fire()

func fire_up():
	firing = false

func _fire():
	if(rounds_in_clip <= 0):
		$asp_dry_fire.play()
		return
	rounds_in_clip -= 1
	disabled = true
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

func spawn_bullet(_direction = Vector2.ZERO, _speed = 0,  _death  = 0):
	var bullet : Bullet = bullet_scene.instantiate()
	bullet.bullet_type = Bullet.BulletType.FLAT
	global_collisions.set_player_bullet(bullet)
	global.current_level.add_to_ysort(bullet)
	var x = get_parent().scale.x
	bullet.bullet_owner = gun_owner
	
	if(_direction.y == 0):
		print(x)
		print($gun_sprites.rotation)
		var direction_new = Vector2(x, sin($gun_sprites.rotation))
		bullet.direction = direction_new
	else:
		bullet.direction = Vector2(x,_direction.y)
	bullet.rotation = $gun_sprites.rotation
	bullet.set_death(_death)
	if(_speed != 0):
		bullet.speed = _speed
	bullet.global_position = $Marker2D.global_position

func release_casing():
	$casings.restart()
	$casings.emitting = true
	
func _on_tmr_shot_delay_timeout() -> void:
	disabled = false
	$gun_sprites.rotation = 0
	if(firing):
		_fire()


func _on_tmr_reload_sound_timeout() -> void:
	$asp_reload.play()


func _on_tmr_decay_timeout() -> void:
	pass # Replace with function body.
