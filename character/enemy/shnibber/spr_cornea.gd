# spr_cornea.gd
extends Sprite2D
class_name Eye

@export var ring_radius: float = 14.0
@export var slide_speed: float = 120.0
@export var retarget_interval: float = 0.25
@export var return_to_center_when_none: bool = true

var _target_player: Node = null
var _retarget_timer: Timer

func _ready() -> void:
	position = Vector2.ZERO

	_retarget_timer = Timer.new()
	_retarget_timer.one_shot = false
	_retarget_timer.wait_time = retarget_interval
	add_child(_retarget_timer)
	_retarget_timer.timeout.connect(_retarget)
	_retarget_timer.start()

	_retarget()

func _retarget() -> void:
	if player_manager == null:
		_target_player = null
		return

	var center_global := _get_center_global_pos()
	_target_player = player_manager.get_nearest_player(center_global)

func _physics_process(delta: float) -> void:
	var desired_local := Vector2.ZERO

	if _target_player != null:
		if "player_dead" in _target_player and _target_player.player_dead:
			_target_player = null
		else:
			var center_global := _get_center_global_pos()
			var to_player: Vector2 = _target_player.global_position - center_global

			if to_player.length() > 0.0001:
				desired_local = to_player.normalized() * ring_radius

	if _target_player == null and return_to_center_when_none:
		desired_local = Vector2.ZERO

	# orbit around parent center (0,0 in parent space)
	position = position.move_toward(desired_local, slide_speed * delta)

func _get_center_global_pos() -> Vector2:
	var p := get_parent()
	if p != null and p is Node2D:
		return (p as Node2D).global_position
	return global_position
