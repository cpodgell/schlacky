# player_manager.gd
extends Node

var players: Array[Node] = []
@onready var PlayerScene := preload("res://character/player/player.tscn")

func _ready() -> void:
	pass

func create_players():
	players.clear()
	for i in range(global.number_of_players):
		var player: Player = PlayerScene.instantiate()
		players.append(player)
		add_child(player)
		player.set_player_number(i)

func get_players() -> Array:
	return players

func get_nearest_player(from_global_pos: Vector2) -> Node:
	var nearest: Node = null
	var nearest_dist_sq := INF

	for p in players:
		if p == null:
			continue
		# Ignore dead players (expects bool var: player_dead)
		if "player_dead" in p and p.player_dead:
			continue

		var d_sq := from_global_pos.distance_squared_to(p.global_position)
		if d_sq < nearest_dist_sq:
			nearest_dist_sq = d_sq
			nearest = p

	return nearest
