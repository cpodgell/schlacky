extends TextureProgressBar

var max_health = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	max_value = max_health
	pass # Replace with function body.

func reset():
	value = max_health

func add_health(_value):
	value += _value
	visible = true
	$Timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	visible = false
