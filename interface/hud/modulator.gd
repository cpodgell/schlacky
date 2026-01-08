extends Node

var node_to_modulate: CanvasItem
var modulate_color: Color = Color.FIREBRICK
var is_modulating_node: bool = false

@export var speed: float = 5.0

var t := 0.0

func _ready() -> void:
	node_to_modulate = get_parent() as CanvasItem

func set_modulating_node(_is_modulating_node : bool):
	is_modulating_node = _is_modulating_node
	if(!is_modulating_node):
		node_to_modulate.modulate = Color.WHITE

func modulate_node_animate(delta):
	# oscillates between 0 → 1 → 0
	t += delta * speed
	var blend := (sin(t) + 1.0) * 0.5

	node_to_modulate.modulate = Color.WHITE.lerp(modulate_color, blend)

func _process(delta: float) -> void:
	if node_to_modulate == null or !is_modulating_node:
		return
	modulate_node_animate(delta)
	
