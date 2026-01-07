extends AnimatableBody2D

@export var path: Path2D
@export var duration: float = 2.0
@export var start_ratio: float = 0.0

var _t: float = 0.0
var _dir: float = 1.0

func _ready() -> void:
	_t = clamp(start_ratio, 0.0, 1.0)
	_set_pos_from_t(_t)

func _physics_process(delta: float) -> void:
	if path == null or path.curve == null:
		return

	_t += (_dir * delta) / max(duration, 0.001)

	if _t >= 1.0:
		_t = 1.0
		_dir = -1.0
	elif _t <= 0.0:
		_t = 0.0
		_dir = 1.0

	_set_pos_from_t(_t)

func _set_pos_from_t(t: float) -> void:
	var te := t * t * (3.0 - 2.0 * t) # smoothstep ease
	var curve := path.curve
	var len := curve.get_baked_length()
	var local_point := curve.sample_baked(te * len)
	global_position = path.to_global(local_point)
