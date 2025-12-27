# DynamicCamera2D.gd
extends Camera2D

@export var edge_margin_px = 400.0          # pixels from screen edge
@export var zoom_smooth = 8.0               # higher = snappier

# Godot: smaller zoom = zoom OUT (see more), larger zoom = zoom IN
@export var min_zoom = 2.0                  # most zoomed OUT allowed
@export var max_zoom = 2.9                  # most zoomed IN allowed

func _ready() -> void:
	make_current()

func update_camera(delta: float) -> void:
	var players = player_manager.players
	if players.is_empty():
		return

	# --- bounds of all player positions ---
	var min_p = Vector2(INF, INF)
	var max_p = Vector2(-INF, -INF)

	for p in players:
		if p == null:
			continue
		var pos = p.global_position
		min_p.x = min(min_p.x, pos.x)
		min_p.y = min(min_p.y, pos.y)
		max_p.x = max(max_p.x, pos.x)
		max_p.y = max(max_p.y, pos.y)

	if min_p.x == INF:
		return

	# --- center camera ---
	var center = (min_p + max_p) * 0.5
	var t = clamp(zoom_smooth * delta, 0.0, 1.0)
	global_position = global_position.lerp(center, t)

	# --- compute required zoom so bounds fit inside viewport with margin ---
	var vp = get_viewport_rect().size
	if vp.x <= 0.0 or vp.y <= 0.0:
		return

	var usable_w = vp.x - (edge_margin_px * 2.0)
	var usable_h = vp.y - (edge_margin_px * 2.0)

	# prevent divide-by-zero / negative usable area
	usable_w = max(usable_w, 1.0)
	usable_h = max(usable_h, 1.0)

	var bounds_w = max_p.x - min_p.x
	var bounds_h = max_p.y - min_p.y

	# if only one player / identical positions, avoid zero-size bounds
	bounds_w = max(bounds_w, 1.0)
	bounds_h = max(bounds_h, 1.0)

	# Godot fit math:
	# screen_visible_world = vp / zoom
	# need visible_world >= bounds_world  => zoom <= vp/bounds
	# with margins => use usable_w/usable_h instead of vp
	var fit_zoom_x = usable_w / bounds_w
	var fit_zoom_y = usable_h / bounds_h

	# must satisfy both, so take the smaller zoom (more zoomed out) requirement
	var target = min(fit_zoom_x, fit_zoom_y)

	# clamp
	target = clamp(target, min_zoom, max_zoom)

	# smooth zoom
	zoom = zoom.lerp(Vector2(target, target), t)
