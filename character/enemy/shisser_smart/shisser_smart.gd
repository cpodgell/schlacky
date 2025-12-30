extends CharacterBody2D

@export var speed: float = 30.0
# The direction the enemy is currently moving (-1 for left, 1 for right)
var direction: int = 1
var dead = false

func _ready() -> void:
	$AnimationPlayer.play("Walk")
	global_collisions.set_enemy(self)
	# Set the collision mask to detect the player and walls, but prevent being pushed by the player


func take_damage(_damage) -> int:
	$blood.play_blood()
	var health = $Health.remove_health(_damage)
	if(health <= 0):
		$ara_top/cls_top.set_deferred("disabled", true)
		$Health.death(self)
	return health

func _physics_process(delta: float) -> void:
	
	# Apply gravity to the vertical velocity (y)
	if not is_on_floor():  # Only apply gravity if the enemy is not on the floor
		velocity.y += get_gravity().y * delta  # Apply gravity based on delta
	
	# Set the velocity based on the current direction and speed
	velocity.x = direction * speed
	
	# Move the enemy using the physics engine
	move_and_slide()  # Use Vector2.UP for correct sliding behavior
	platform_edge()
	# If the enemy is on a wall, reverse direction
	if is_on_wall():
		direction *= -1
		# Optionally flip the sprite horizontally to face the new direction
		$Sprite2D.flip_h = (direction == -1)
		
func platform_edge():
	if not $EdgeRayCast.is_colliding():
		direction = -direction
		$EdgeRayCast.position.x = -1*$EdgeRayCast.position.x
		$Sprite2D.flip_h = (direction == -1)

func _on_ara_top_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.velocity.y >= 0:
			speed = 0
			body.velocity.y = -200
			global_collisions.set_enemy_dead_walls(self)
			$ara_top/cls_top.set_deferred("disabled", true)
			$Health.play_death_sound()
			$AnimationPlayer.play("Squish")
