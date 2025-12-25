class_name BaseLevel extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_players():
	$ysort.add_child(player_manager.player_0)
	$ysort.add_child(player_manager.player_1)
	$ysort.add_child(player_manager.player_2)
	$ysort.add_child(player_manager.player_3)
	player_manager.player_0.global_position = $start_positions/start_position_0.global_position
	player_manager.player_1.global_position = $start_positions/start_position_1.global_position
	player_manager.player_2.global_position = $start_positions/start_position_2.global_position
	player_manager.player_3.global_position = $start_positions/start_position_3.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
