extends Area2D


var time_length
var damage_colider : CollisionShape2D
var explosion : Explosion
@export var show_explosion = true
@export var damage_amount = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(show_explosion):
		_add_explosion()
	for i in get_children():
		if i is CollisionShape2D:
			damage_colider = i
			damage_colider.disabled = true
	pass # Replace with function body.

func play_damage():
	damage_colider.disabled = false
	if(show_explosion):
		explosion.play_explosion()
		$asp_explode_sound.play()
	$tmr_apply_damage.start()

func _add_explosion():
	show_explosion = true
	explosion = preload("res://effects/explosion.tscn").instantiate()
	self.add_child(explosion)
	explosion.global_position = self.global_position

func _on_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		body.take_damage(damage_amount)
		explosion.play_explosion()

func _on_tmr_apply_damage_timeout() -> void:
	damage_colider.disabled = true
	#queue_free()
