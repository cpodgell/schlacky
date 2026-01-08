extends StaticBody2D

var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func take_damage(_damage) -> int:
	if(!is_dead):
		$brick_debris.play()
		$spr_brick.visible = false
		$AudioStreamPlayer.pitch_scale = randf_range(.6, 1.1) # Randomly pick a sound
		$AudioStreamPlayer.play()
		$tmr_cls_disable.start()
		is_dead = true
	return 1

func set_brick(_frame):
	$spr_brick.frame = _frame
	if(_frame == 0):
		$brick_debris.set_blue()
	else:
		$brick_debris.set_brown()

func _on_tmr_cls_disable_timeout() -> void:
	$cls_brick.set_deferred("disabled", true)

func _on_brick_debris_block_debris_finished() -> void:
	queue_free()
