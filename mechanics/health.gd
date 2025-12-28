extends Node

var node = null
var health = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func remove_health(_damage):
	health -= _damage
	return health

func death(_node):
	$AudioStreamPlayer.play()
	node = _node.get_node("Sprite2D")
	_node.velocity.y = -300
	_node.get_node("Collision2D").set_deferred("disabled", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(node):
		node.rotation += .1
		
