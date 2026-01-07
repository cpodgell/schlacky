@tool
class_name Item
extends CharacterBody2D

@export var gravity: float = 1200.0
@export var max_fall_speed: float = 2000.0

# GUN-ONLY ITEM: pick which gun this pickup represents
@export var weapon_type: GameDefs.WeaponType = GameDefs.WeaponType.PISTOL:
	set(value):
		weapon_type = value
		_update_sprite()

# Optional: still allow spawning a scene on pickup (ex: a fancy gun node)
@export var spawner_scene: PackedScene

@onready var spr_item: Sprite2D = $spr_item

# Design-time sprites keyed by WeaponType (placeholders — swap paths)
var weapon_sprites: Dictionary = {
	GameDefs.WeaponType.PISTOL: preload("res://assets/gun/pistol.png"),
	GameDefs.WeaponType.SHOTGUN: preload("res://assets/gun/shotgun.png"),
	GameDefs.WeaponType.MACHINE_GUN: preload("res://assets/gun/machine_gun.png"),
	GameDefs.WeaponType.UZI: preload("res://assets/gun/uzi.png"),
	GameDefs.WeaponType.LASER: preload("res://assets/gun/laser_gun.png"),
	GameDefs.WeaponType.ROCKET_LAUNCHER: preload("res://assets/gun/rocket_launcher.png"),
}

var _settled := false
var _payload: Node = null


func _ready() -> void:
	add_to_group("gun")
	_update_sprite()

	# Don't spawn payload while editing in the editor
	if Engine.is_editor_hint():
		return

	# Only used if you actually want a runtime payload node for this item
	if spawner_scene:
		_payload = spawner_scene.instantiate()
		add_child(_payload)


func _physics_process(delta: float) -> void:
	if _settled:
		return

	velocity.x = 0.0
	velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	move_and_slide()

	if is_on_floor():
		velocity = Vector2.ZERO
		_settled = true
		set_physics_process(false)


func pickup(player: Player) -> void:
	if player != null:
		print("not null")
		if player.name == "Player":
			print("is player")
			if player.has_method("pickup_gun"):
				player.call("pickup_gun", weapon_type)
	queue_free()


func _update_sprite() -> void:
	if not spr_item:
		return

	var tex: Texture2D = weapon_sprites.get(weapon_type, null)
	if tex:
		spr_item.texture = tex


func _on_item_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
