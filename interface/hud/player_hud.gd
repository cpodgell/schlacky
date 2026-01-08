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

func set_total_bullets_max(_ammo_total_max : int):
	total_bullets_max = _ammo_total_max
	set_bullet_label()

func set_bullet_clip_amount(_clip_amount : int):
	bullet_label_total.text = str(_clip_amount)

func set_bullet_max(_max  : int):
	bullet_clip_max = _max
	set_bullet_label()
	
func set_bullet_amount(_bullet_amount):
	bullet_clip_amount = _bullet_amount
	set_bullet_label()

func set_bullet_label():
	if(float(bullet_clip_amount) / float(bullet_clip_max)) < .30:
		$lbl_bullet_amount/Modulator.set_modulating_node(true)
	else:
		$lbl_bullet_amount/Modulator.set_modulating_node(false)
	bullet_label_total.text = str(total_bullets_max)
	bullet_label.text = str(bullet_clip_max) + "/" + str(bullet_clip_amount)
