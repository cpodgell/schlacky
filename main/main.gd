class_name Main extends Node2D

@export var number_of_players: int = 1
@export var testing : bool = true

var game_camera : GameCamera = null
var title_screen

var music_00 = preload("res://assets/sfx/music/Owl City Fireflies - Sungha Jung (Cover).mp3")
var music_01 = preload("res://assets/sfx/music/TPS (Cover).mp3")
var music = [music_00, music_01]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.main = self
	initialize()
	if(testing):
		start_game()
	else:
		$Camera2D.enabled = false
		$CanvasLayer/HUD.visible = false
		title_screen = preload("res://screens/TitleScreen.tscn").instantiate()
		add_child(title_screen)
		title_screen.connect("start_pressed", Callable(self, "_on_title_screen_start_pressed") )
	#global.number_of_players = number_of_players
	#player_manager.create_players()
	pass # Replace with function body.

func initialize():
	var screen_width = get_viewport().size.x  # Get the width of the screen
	
	# Divide the screen width by 4
	var division = screen_width / 4.0

	# Loop through the children of the HUD and set their global positions
	var children = $CanvasLayer/HUD.get_children()
	for i in range(children.size()):
		var child = children[i]
		
		# Set the x position based on the index, with uniform spacing
		child.global_position.x = division * (i) + 100 # Use 0.5 to center them
		
		# Keep y position the same as the original (or change it if needed)
		child.global_position.y = 20  # Or set it to a specific value


func _physics_process(delta: float) -> void:
	if(game_camera):
		$Camera2D.update_camera(delta)

func start_game():
	game_camera = $Camera2D
	game_camera.make_current()
	global.number_of_players = number_of_players
	
	$Camera2D.enabled = true
	$CanvasLayer/HUD.visible = true
	
	player_manager.create_players()
	load_level()

func load_level():
	$asp_music.stream = music[randi_range(0,music.size() - 1)]
	$asp_music.play()
	var current_level = preload("res://level/level_04.tscn").instantiate()
	global.current_level = current_level
	$staging.add_child(current_level)
	global.current_level.add_players()

func update_hud(_bullet_max, _bullet_amount, _player_number):
	var HUD = get_hud(_player_number)
	HUD.set_bullet_max(_bullet_max)
	HUD.set_bullet_amount(_bullet_amount)

func get_hud(_number) -> PlayerHUD:
	return get_node("CanvasLayer/HUD/Player_HUD_" + str(_number))

func _on_title_screen_start_pressed() -> void:
	#title_screen.queue_free()
	start_game()
