extends Node

# 1-based collision layer numbers (Godot 4 uses 1..32)
const ENVIRONMENT		= 1
const WALLS			= 2
const PLAYER			= 3
const ENEMY			= 4
const PLAYER_BULLET	= 5
const ENEMY_BULLET	= 6
const PLAYER_HB		= 7
const ENEMY_HB		= 8
const PICKUPS		= 9
const PICKER_UPPER	= 10
const ENVIRONMENT_HB	= 11
const DETECTORS		= 12

var collisions: Array

func _ready() -> void:
	collisions = []
	for i in range(1, 33):	# layers 1..32
		collisions.append(i)


func set_layer_bits(body: CollisionObject2D, array: Array, bit := true) -> void:
	for idx in array:
		body.set_collision_layer_value(int(idx), bit)

func set_mask_bits(body: CollisionObject2D, array: Array, bit := true) -> void:
	for idx in array:
		body.set_collision_mask_value(int(idx), bit)

func set_all_layer_bits(body: CollisionObject2D, bit := true) -> void:
	for i in collisions:
		body.set_collision_layer_value(i, bit)

func set_all_mask_bits(body: CollisionObject2D, bit := true) -> void:
	for i in collisions:
		body.set_collision_mask_value(i, bit)
		
		
func set_player(body: PhysicsBody2D) -> void:
	set_layer_bits(body, [PLAYER])				# is Player (3)
	set_mask_bits(body, [ENVIRONMENT, WALLS, PLAYER])		# collides with Env (1) + Enemy (4)
