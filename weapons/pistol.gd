extends Node2D

var bullet_scene = preload("res://weapons/bullets/bullet.tscn")
var gun_owner
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gun_owner = get_parent().get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire():
	spawn_bullet()
	
func spawn_bullet():
	$AudioStreamPlayer.play()
	var bullet : Bullet = bullet_scene.instantiate()
	global.current_level.add_bullet(bullet)
	var x = get_parent().scale.x
	bullet.bullet_owner = gun_owner
	bullet.direction = Vector2(x,0)
	bullet.global_position = $Marker2D.global_position
