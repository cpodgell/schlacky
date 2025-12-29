# DynamicCamera2D.gd
extends Camera2D

@export var edge_margin_px = 300.0
@export var zoom_smooth = 8.0

# Godot: smaller zoom = zoom OUT, larger zoom = zoom IN
@export var min_zoom = 1.2
@export var max_zoom = 3.5

func _ready() -> void:
	make_current()

func update_camera(delta: float) -> void:
	var players = player_manager.players
	if players.is_empty():
		return

	# --- collect alive players only ---
	var alive_players = []
	for p in players:
		if p == null:
			continue
		if p.player_dead:
			continue
		alive_players.append(p)

	if alive_players.is_empty():
		return

	var t = clamp(zoom_smooth * delta, 0.0, 1.0)

	# --- single alive player: lock + max zoom ---
	if alive_players.size() == 1:
		var p = alive_players[0]
		global_position = global_position.lerp(p.global_position, t)
		zoom = zoom.lerp(Vector2(max_zoom, max_zoom), t)
		return

	# --- bounds of alive players ---
	var min_p = Vector2(INF, INF)
	var max_p = Vector2(-INF, -INF)

	for p in alive_players:
		var pos = p.global_position
		min_p.x = min(min_p.x, pos.x)
		min_p.y = min(min_p.y, pos.y)
		max_p.x = max(max_p.x, pos.x)
		max_p.y = max(max_p.y, pos.y)

	# --- center camera ---
	var center = (min_p + max_p) * 0.5
	global_position = global_position.lerp(center, t)

	# --- compute zoom ---
	var vp = get_viewport_rect().size
	if vp.x <= 0.0 or vp.y <= 0.0:
		return

	var usable_w = max(vp.x - edge_margin_px * 2.0, 1.0)
	var usable_h = max(vp.y - edge_margin_px * 2.0, 1.0)

	var bounds_w = max(max_p.x - min_p.x, 1.0)
	var bounds_h = max(max_p.y - min_p.y, 1.0)

	var fit_zoom_x = usable_w / bounds_w
	var fit_zoom_y = usable_h / bounds_h

	var target = min(fit_zoom_x, fit_zoom_y)
	target = clamp(target, min_zoom, max_zoom)

	zoom = zoom.lerp(Vector2(target, target), t)
