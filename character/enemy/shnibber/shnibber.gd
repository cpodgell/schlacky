extends CharacterBody2D

@export var speed: float = 30.0
# The direction the enemy is currently moving (-1 for left, 1 for right)
var direction: int = 1
var dead = false
var injured = false

func _ready() -> void:
	$AnimationPlayer.play("walk")
	# Set the collision mask to detect the player and walls, but prevent being pushed by the player
	collision_mask = 2 | 3 | 4  # Layer 2 for walls, and Layer 3 and 4 for any other layers you need
	# Collision layer 1 is for the enemy (or whatever you need)
	collision_layer = 4

func take_damage(_damage) -> bool:
	
	$blood.play_blood()
	var health = $Health.remove_health(_damage)
	injured = true
	$tmr_recover.start()
	$AnimationPlayer.play("injure")
	if(health <= 0):
		$Health.death(self)
		return true
	return false

func _physics_process(delta: float) -> void:
	# Apply gravity to the vertical velocity (y)
	if not is_on_floor():  # Only apply gravity if the enemy is not on the floor
		velocity.y += get_gravity().y * delta  # Apply gravity based on delta
	
	# Set the velocity based on the current direction and speed
	velocity.x = direction * speed
	if(injured):
		velocity.x = 0
	# Move the enemy using the physics engine
	move_and_slide()  # Use Vector2.UP for correct sliding behavior

	# If the enemy is on a wall, reverse direction
	if is_on_wall():
		direction *= -1
		# Optionally flip the sprite horizontally to face the new direction
		$Sprite2D.flip_h = (direction == -1)


func _on_tmr_recover_timeout() -> void:
	injured = false
	$AnimationPlayer.play("walk")
