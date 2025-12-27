extends Node2D

@export var weapon_type : int

enum WeaponType {
	PISTOL,
	SHOTGUN,
	MACHINE_GUN
}

signal reload(time)
var shots_before_reload = 1
var shots_counter = 0

var bullet_scene = preload("res://weapons/bullets/bullet.tscn")
var gun_owner

@onready var pistol = $gun_sprites/spr_gun
@onready var shotgun = $gun_sprites/spr_shot_gun

var machine_gun
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in $gun_sprites.get_children():
		c.visible = false
	match weapon_type:
		WeaponType.PISTOL:
			pistol.visible = true
		WeaponType.SHOTGUN:
			shotgun.visible = true
		WeaponType.MACHINE_GUN:
			machine_gun.visible = true
	gun_owner = get_parent().get_parent()
	pass # Replace with function body.

func fire():
	if(weapon_type == WeaponType.SHOTGUN):
		for i in 10:
			var spread = randf_range(-.15, .15)
			var speed = randf_range(200, 450)
			spawn_bullet(Vector2(0,spread), speed)
			$asp_shotgun.play()
	if(weapon_type == WeaponType.PISTOL):
		var speed = 500
		$asp_pistol.play()
		spawn_bullet(Vector2.ZERO, speed)
	
func spawn_bullet(_direction = Vector2.ZERO, _speed = 0):
	var bullet : Bullet = bullet_scene.instantiate()
	global.current_level.add_to_ysort(bullet)
	var x = get_parent().scale.x
	bullet.bullet_owner = gun_owner
	bullet.direction = Vector2(x,_direction.y)
	if(_speed != 0):
		bullet.speed = _speed
	bullet.global_position = $Marker2D.global_position
