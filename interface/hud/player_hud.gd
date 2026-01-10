class_name PlayerHUD extends Control

var bullet_clip_max = 0
var bullet_clip_amount = 0

var total_bullets_max = 0
var total_bullets_amount = 0

@onready var bullet_label : Label = $lbl_bullet_amount
@onready var bullet_label_total : Label = $lbl_bullet_amount_total

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Set the max clip bullets
func set_bullet_max(_max  : int):
	bullet_clip_max = _max
	set_bullet_label()

# Set the current clip ammo
func set_bullet_amount(_bullet_amount):
	bullet_clip_amount = _bullet_amount
	set_bullet_label()

# Set the total max bullets
func set_total_bullets_max(_ammo_total_max : int):
	total_bullets_max = _ammo_total_max
	set_bullet_label()

# Set the total ammo
func set_bullet_clip_amount(_clip_amount : int, _bullet_total_amount : int):
	bullet_label_total.text = str(_bullet_total_amount)  # Set the total ammo amount here
	bullet_label.text = str(bullet_clip_max) + "/" + str(_clip_amount) # Display clip amount as "current/max"

# Update the bullet labels and modulate based on ammo
func set_bullet_label():
	# Change the color of the label when ammo is below 30%
	if(float(bullet_clip_amount) / float(bullet_clip_max)) < .30:
		bullet_label.modulate = Color(1, 0, 0)  # Red color for low ammo
	else:
		bullet_label.modulate = Color(1, 1, 1)  # White color for normal ammo
	
	# Display total bullets max in the total label
	bullet_label_total.text = str(total_bullets_max)
	
	# Update the clip ammo label: current ammo/total clip max
	bullet_label.text =  str(bullet_clip_max) + "/" + str(bullet_clip_amount)
