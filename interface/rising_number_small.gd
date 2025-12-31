extends Control

var health_playing = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lbl_text.text = ""
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.y -= 1 * delta
	pass

func play_number(_number):
	if(health_playing):
		_number = int($lbl_text.text) + _number
	health_playing = true
	$lbl_text.text = str(_number)
	$lbl_text.position = Vector2(0,0)
	$AnimationPlayer.play("text_rise")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	health_playing = false
	$lbl_text.text = ""
