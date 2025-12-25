extends Node

var player_0
var player_1
var player_2
var player_3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func create_players():
	player_0 = load("res://character/player/player.tscn").instantiate()
	player_1 = load("res://character/player/player.tscn").instantiate()
	player_2 = load("res://character/player/player.tscn").instantiate()
	player_3 = load("res://character/player/player.tscn").instantiate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
