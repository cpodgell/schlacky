@tool
class_name Item
extends CharacterBody2D

@export var gravity: float = 1200.0
@export var max_fall_speed: float = 2000.0

# What this item spawns / represents
@export var spawner_scene: PackedScene

# DESIGN-TIME selector
@export var item_type: int = 0:
	set(value):
		item_type = value
		_update_sprite()

@onready var texture: Texture2D = load("res://path/to/texture.png")
# DESIGN-TIME visuals (drag any placeholder textures here)
@export var item_sprites: Array[Texture2D] = [texture]

@onready var item_area: Area2D = $item_area
@onready var spr_item: Sprite2D = $item_area/spr_item

var _settled := false
var _payload: Node = null


func _ready() -> void:
	_update_sprite()

	if Engine.is_editor_hint():
		return

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


func pickup() -> void:
	queue_free()


func _update_sprite() -> void:
	if not spr_item:
		return
	if item_type >= 0 and item_type < item_sprites.size():
		spr_item.texture = item_sprites[item_type]
