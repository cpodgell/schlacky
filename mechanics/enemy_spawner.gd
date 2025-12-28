extends Node2D

@export var enemy_scene : PackedScene  # Export PackedScene
@export var spawn_frequency : int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	$Timer.wait_time = spawn_frequency
	$Timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_node():
	var enemy = enemy_scene.instantiate()
	global.current_level.add_to_ysort(enemy)
	enemy.global_position = global_position

func _on_timer_timeout() -> void:
	spawn_node()
