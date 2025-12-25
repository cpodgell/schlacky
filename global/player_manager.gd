extends Node

var players: Array[Node] = []
@onready var PlayerScene := preload("res://character/player/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func create_players():
	players.clear()
	for i in range(global.number_of_players):
		var player = PlayerScene.instantiate()
		players.append(player)
		add_child(player)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
