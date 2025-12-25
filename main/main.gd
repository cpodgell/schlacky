extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_manager.create_players()
	load_level()
	
	pass # Replace with function body.

func load_level():
	var current_level = preload("res://level/level_02.tscn").instantiate()
	global.current_level = current_level
	$staging.add_child(current_level)
	global.current_level.add_players()
