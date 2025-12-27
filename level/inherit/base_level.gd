class_name BaseLevel extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_players():
	var start_positions := $start_positions.get_children()
	start_positions.sort_custom(func(a, b): return a.name < b.name)

	for i in range(player_manager.players.size()):
		var player = player_manager.players[i]

		if player.get_parent() != $ysort:
			player.reparent($ysort)

		if i < start_positions.size():
			player.global_position = start_positions[i].global_position
			player.start_position = start_positions[i].global_position
			player.set_player_color(start_positions[i].modulate)

func add_to_ysort(_object):
	$ysort.add_child(_object)

func _process(delta: float) -> void:
	pass
