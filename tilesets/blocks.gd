extends TileMapLayer

@export var block_scene: PackedScene = preload("res://objects/brick.tscn")
@export var y_offset: int = 0
@export var erase_tiles_after_spawning: bool = true

func _ready() -> void:
	place_blocks()

func place_blocks() -> void:
	var used_cells: Array[Vector2i] = get_used_cells()

	for cell: Vector2i in used_cells:
		# Optional: only spawn blocks for tiles that actually exist
		var td: TileData = get_cell_tile_data(cell)
		if td == null:
			continue

		var block: Node2D = block_scene.instantiate()

		add_child(block)

		# Top-left corner of the tile in GLOBAL coords
		var local_pos: Vector2 = map_to_local(cell)
		block.global_position = to_global(local_pos) + Vector2(0, y_offset)

		# Optional: remove the tile so it doesn't draw under the spawned object
		if erase_tiles_after_spawning:
			erase_cell(cell)
