extends TileMapLayer

@export var spawner_scene: PackedScene
@export var spawner_frequency: float = 1.0
@export var brown_brick_scene: PackedScene = preload("res://objects/brick.tscn")
@export var erase_tiles_after_spawning: bool = true

func _ready() -> void:
	check_for_block_spawners()

func check_for_block_spawners() -> void:
	var used_cells: Array[Vector2i] = get_used_cells()

	for cell in used_cells:
		var td: TileData = get_cell_tile_data(cell)
		if td == null:
			continue

		var block_type = td.get_custom_data("block_type")

		if block_type == "block_spawner":
			print("BLOCK SPAWNER FOUND AT:", cell)
			falling_block_spawner(cell)
		if block_type == "brown_brick":
			spawn_brown_brick(cell)
		if block_type == "blue_brick":
			spawn_blue_brick(cell)

func falling_block_spawner(cell: Vector2i) -> void:
	var block_spanwer: Node2D = spawner_scene.instantiate()
	add_child(block_spanwer)

	var local_pos: Vector2 = map_to_local(cell)
	block_spanwer.global_position = to_global(local_pos) + Vector2(0,0)
	block_spanwer.set_spawn_frequency(spawner_frequency)
	if erase_tiles_after_spawning:
		erase_cell(cell)
	

func spawn_brown_brick(cell: Vector2i) -> void:
	var brown_brick: Node2D = brown_brick_scene.instantiate()
	brown_brick.set_brick(1)
	add_child(brown_brick)

	var local_pos: Vector2 = map_to_local(cell)
	brown_brick.global_position = to_global(local_pos) + Vector2(0,0)

	if erase_tiles_after_spawning:
		erase_cell(cell)

func spawn_blue_brick(cell: Vector2i) -> void:
	var blue_brick: Node2D = brown_brick_scene.instantiate()
	blue_brick.set_brick(0)
	add_child(blue_brick)

	var local_pos: Vector2 = map_to_local(cell)
	blue_brick.global_position = to_global(local_pos) + Vector2(0,0)

	if erase_tiles_after_spawning:
		erase_cell(cell)
