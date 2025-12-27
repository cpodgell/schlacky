class_name Bullet
extends Area2D

var speed: float = 500.0
var direction: Vector2 = Vector2.ZERO
var enable: bool = true
var damage: int = 1
var bullet_owner 

func initialize(dir: Vector2) -> void:
	enable = true
	direction = dir.normalized()
	$Timer.start()

func _process(delta: float) -> void:
	if !enable:
		return
	global_position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if(body != bullet_owner):
		$Sprite2D.visible = false
		if(body.has_method("take_damage")):
			body.take_damage(damage)
		queue_free()
