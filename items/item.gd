class_name Item extends CharacterBody2D

@export var gravity: float = 1200.0
@export var max_fall_speed: float = 2000.0

var _settled := false

func _physics_process(delta: float) -> void:
	if _settled:
		return
	# straight down only
	velocity.x = 0.0
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed

	move_and_slide()
	# once it hits ground, freeze it
	if is_on_floor():
		velocity = Vector2.ZERO
		_item_settled()

func pickup():
	queue_free()

func _item_settled() -> void:
	_settled = true
	# optional: stop any further physics processing
	set_physics_process(false)
