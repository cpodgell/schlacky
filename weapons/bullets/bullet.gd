# bullet.gd
class_name Bullet
extends Area2D

enum BulletType { BASIC, FLAT }

@export var bullet_type: BulletType = BulletType.BASIC:
	set(value):
		bullet_type = value
		if is_inside_tree():
			_apply_bullet_visuals()

@export var speed: float = 500.0
@export var damage: int = 1
@export var enable: bool = true

var direction: Vector2 = Vector2.ZERO
var bullet_owner: Node = null

@onready var ricochet: Node = $ricochet
@onready var spr_bullet: Sprite2D = $spr_bullet
@onready var tmr_free: Timer = $tmr_free
@onready var cls_bullet: CollisionShape2D = $cls_bullet

const BULLET_TEXTURES := {
	BulletType.BASIC: preload("res://assets/bullets/basic_bullet.png"),
	BulletType.FLAT: preload("res://assets/bullets/flat_bullet.png"),
}

func _ready() -> void:
	tmr_free.start()
	_apply_bullet_visuals()

func _process(delta: float) -> void:
	if not enable:
		return
	global_position += direction * speed * delta

func _apply_bullet_visuals() -> void:
	if spr_bullet == null:
		return
	spr_bullet.texture = BULLET_TEXTURES.get(
		bullet_type,
		BULLET_TEXTURES[BulletType.BASIC]
	)

func set_death(seconds: float) -> void:
	tmr_free.wait_time = seconds
	tmr_free.start()

func destroy_bullet(play_ricochet: bool = true) -> void:
	remove_child(ricochet)
	cls_bullet.disabled = true
	global.current_level.add_to_ysort(ricochet)
	ricochet.global_position = global_position
	ricochet.play_ricochet()
	queue_free()

func _on_timer_timeout() -> void:
	destroy_bullet()

func _on_body_entered(body: Node2D) -> void:
	if body == bullet_owner:
		return

	var health = 1000
	if body.has_method("take_damage"):
		health = body.take_damage(damage)
	
	if health >= 0:
		destroy_bullet()
