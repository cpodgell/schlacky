extends Node2D

var body_in_way = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	body_in_way = body
	$Enemy_Spawner.disabled = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == body_in_way:
		body_in_way = null
		$Enemy_Spawner.disabled = false
