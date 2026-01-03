extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_A):
		$Control/sprite_body.play_idle()
	if Input.is_key_pressed(KEY_D):
		$Control/sprite_body.play_walk()
	if Input.is_key_pressed(KEY_Q):
		$Control/sprite_body.decrease_hat()
	if Input.is_key_pressed(KEY_E):
		$Control/sprite_body.increase_hat()
