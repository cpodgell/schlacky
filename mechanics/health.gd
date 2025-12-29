extends Node

var node = null
var health = 2

@export var hurt_sound: AudioStream
@export var death_sound: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$asp_hurt.stream = hurt_sound
	$asp_death.stream = death_sound
	pass # Replace with function body.

func play_death_sound():
	$asp_death.play()

func play_hurt_sound():
	$asp_hurt.play()

func remove_health(_damage):
	play_hurt_sound()
	health -= _damage
	return health

func death(_node):
	play_death_sound()
	node = _node.get_node("Sprite2D")
	_node.velocity.y = -300
	_node.get_node("Collision2D").set_deferred("disabled", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(node):
		node.rotation += .1
		
