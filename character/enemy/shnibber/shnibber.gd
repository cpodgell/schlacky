extends CharacterBody2D

@export var speed: float = 30.0
# The direction the enemy is currently moving (-1 for left, 1 for right)
var direction: int = 1
var dead = false
var injured = false

var bullet_scene = preload("res://weapons/bullets/bullet.tscn")

func _ready() -> void:
	$AnimationPlayer.play("walk")
	# Set the collision mask to detect the player and walls, but prevent being pushed by the player
	collision_mask = 2 | 3 | 4  # Layer 2 for walls, and Layer 3 and 4 for any other layers you need
	# Collision layer 1 is for the enemy (or whatever you need)
	collision_layer = 4
	$tmr_shoot.start()

func take_damage(_damage) -> int:
	$blood.play_blood()
	var health = $Health.remove_health(_damage)
	$tmr_recover.start()
	$AnimationPlayer.play("injure")
	$Sprite2D/Node2D/spr_cornea.visible = false
	if(!injured) and health > 0:
		$Health.play_hurt_sound()
		injured = true
	if(health <= 0):
		$Health.play_death_sound()
		$Health.death(self)
	return health

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
		if(direction < 0):
			$Sprite2D/Node2D.global_position = $mkr_left.global_position
		else:
			$Sprite2D/Node2D.global_position = $mkr_right.global_position

func spawn_bullet(_direction = Vector2.ZERO, _speed = 0,  _death  = 0):
	var bullet : Bullet = bullet_scene.instantiate()
	global.current_level.add_to_ysort(bullet)
	bullet.bullet_owner = self
	bullet.direction = $Sprite2D/Node2D/spr_cornea.get_direction()
	bullet.set_death(_death)
	bullet.speed = 100
	bullet.global_position = $Sprite2D/Node2D/spr_cornea.global_position
	global_collisions.set_enemy_bullet(bullet)

func _on_tmr_recover_timeout() -> void:
	injured = false
	$Sprite2D/Node2D/spr_cornea.visible = true
	$AnimationPlayer.play("walk")


func _on_tmr_shoot_timeout() -> void:
	spawn_bullet()
