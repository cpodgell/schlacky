extends Node2D

signal start_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.modulate = Color(randf(), randf(), randf())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p0_start"):
		# Print a message to the output
		emit_signal("start_pressed")
		queue_free()
		
