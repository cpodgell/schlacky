extends state


func enter():
	host_reference.player_dead = true
	host_reference.player_disabled = true
	global_collisions.set_all_layer_bits(host_reference, false)
	global_collisions.set_all_mask_bits(host_reference, false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_state() -> String:
	return name.to_lower()
