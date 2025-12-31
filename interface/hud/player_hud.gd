class_name PlayerHUD extends Control

var bullet_max = 0
var bullet_amount
@onready var bullet_label : Label = $lbl_bullet_amount
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_bullet_max(_max  : int):
	bullet_max = _max
	set_bullet_label()
	
func set_bullet_amount(_bullet_amount):
	bullet_amount = _bullet_amount
	set_bullet_label()

func set_bullet_label():
	bullet_label.text = str(bullet_max) + "/" + str(bullet_amount)
