extends Node2D

@export var number_of_players: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.number_of_players = number_of_players
	player_manager.create_players()
	$Camera2D.make_current()
	load_level()
	
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	$Camera2D.update_camera(delta)

func load_level():
	var current_level = preload("res://level/level_03.tscn").instantiate()
	global.current_level = current_level
	$staging.add_child(current_level)
	global.current_level.add_players()
	
