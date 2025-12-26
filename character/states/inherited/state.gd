class_name state extends Node

var state_end_cost = 0
var host_reference : Player
var sprite_body_reference : Sprite_Body

# Initialize the state. E.g. change the animation
func enter():
	pass

func handle_input(event):
	pass

func update(delta):
	pass

# Clean up the state. Reinitialize values like a timer
func exit():
	pass

func animation_finished(_current_anim_state):
	pass
