extends PathFollow2D

@export var duration: float = 2.0

var _tween: Tween

func _ready() -> void:
	rotates = false
	progress_ratio = 0.0

	_tween = create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) # critical
	_tween.set_loops()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_IN_OUT)

	_tween.tween_property(self, "progress_ratio", 1.0, duration)
	_tween.tween_property(self, "progress_ratio", 0.0, duration)
