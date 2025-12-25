extends Node2D

@export var number_of_players: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.number_of_players = number_of_players
	player_manager.create_players()
	$Camera2D.is_current()
	load_level()
	
	pass # Replace with function body.

func load_level():
	var current_level = preload("res://level/level_02.tscn").instantiate()
	global.current_level = current_level
	$staging.add_child(current_level)
	global.current_level.add_players()
	if(player_manager.players.size() > 0):
		$Camera2D.target = player_manager.players[0]
