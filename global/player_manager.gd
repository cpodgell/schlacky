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
