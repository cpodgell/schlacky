extends TileMapLayer

@export var spawner_scene: PackedScene = preload("res://mechanics/spawners/brick_spawner.tscn")
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
			spawn_falling_block(cell)
		if block_type == "brown_brick":
			spanw_brown_brick(cell)

func spawn_falling_block(cell: Vector2i) -> void:
	var block_spanwer: Node2D = spawner_scene.instantiate()
	add_child(block_spanwer)

	var local_pos: Vector2 = map_to_local(cell)
	block_spanwer.global_position = to_global(local_pos) + Vector2(0,0)

	if erase_tiles_after_spawning:
		erase_cell(cell)

func spanw_brown_brick(cell: Vector2i) -> void:
	var brown_brick: Node2D = brown_brick_scene.instantiate()
	add_child(brown_brick)

	var local_pos: Vector2 = map_to_local(cell)
	brown_brick.global_position = to_global(local_pos) + Vector2(0,0)

	if erase_tiles_after_spawning:
		erase_cell(cell)
