extends Node2D

@export var number_of_players: int = 2
@export var testing : bool = false

var game_camera : GameCamera = null
var title_screen

var music_00 = preload("res://assets/sfx/music/Owl City Fireflies - Sungha Jung (Cover).mp3")
var music_01 = preload("res://assets/sfx/music/TPS (Cover).mp3")
var music = [music_00, music_01]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(testing):
		start_game()
	else:
		title_screen = preload("res://screens/TitleScreen.tscn").instantiate()
		add_child(title_screen)
		title_screen.connect("start_pressed", Callable(self, "_on_title_screen_start_pressed") )
	#global.number_of_players = number_of_players
	#player_manager.create_players()
	
	
	
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if(game_camera):
		$Camera2D.update_camera(delta)

func start_game():
	game_camera = preload("res://mechanics/camera_2d.tscn").instantiate()
	add_child(game_camera)
	game_camera.make_current()
	global.number_of_players = number_of_players
	player_manager.create_players()
	load_level()

func load_level():
	$asp_music.stream = music[randi_range(0,music.size() - 1)]
	$asp_music.play()
	var current_level = preload("res://level/level_03.tscn").instantiate()
	global.current_level = current_level
	$staging.add_child(current_level)
	global.current_level.add_players()
	


func _on_title_screen_start_pressed() -> void:
	#title_screen.queue_free()
	start_game()
