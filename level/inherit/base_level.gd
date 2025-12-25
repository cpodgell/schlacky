class_name BaseLevel extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_players():
	var starts := $start_positions.get_children()
	starts.sort_custom(func(a, b): return a.name < b.name)

	for i in range(player_manager.players.size()):
		var player = player_manager.players[i]

		if player.get_parent() != $ysort:
			player.reparent($ysort)

		if i < starts.size():
			player.global_position = starts[i].global_position



func _process(delta: float) -> void:
	pass
