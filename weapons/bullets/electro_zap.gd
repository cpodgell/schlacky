extends Node2D

@export var zap_length := 200.0
@export var segments := 12
@export var jitter := 18.0

@onready var line: Line2D = $Line2D
@onready var line2: Line2D = $Line2D2
@onready var tmr_zap: Timer = $tmr_zap

func _ready():
	tmr_zap.start()
	_rebuild_zap()

func _rebuild_zap():
	line.clear_points()
	line2.clear_points()

	var dir := Vector2.RIGHT
	var step := zap_length / segments

	for i in range(segments + 1):
		var p := dir * step * i

		# random chaos except endpoints
		if i > 0 and i < segments:
			p += Vector2(
				randf_range(-jitter, jitter),
				randf_range(-jitter, jitter)
			)

		line.add_point(p)
		line2.add_point(p)

	# optional flicker
	#line.default_color.a = randf_range(0.6, 1.0)
	#line.default_color.a = randf_range(0.6, 1.0)


func _on_tmr_zap_timeout() -> void:
	_rebuild_zap()
