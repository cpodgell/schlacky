extends Node2D

var body_in_way = null

func  set_spawn_frequency(frequency : float) -> void:
	$Enemy_Spawner.set_spawn_frequency(frequency)

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_in_way = body
	$Enemy_Spawner.disabled = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == body_in_way:
		body_in_way = null
		$Enemy_Spawner.disabled = false
