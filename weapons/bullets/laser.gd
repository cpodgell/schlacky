# laser_beam.gd
class_name LaserBeam
extends RayCast2D

# -------------------------
# CONFIG
# -------------------------
@export var damage: int = 1
@export var beam_length: float = 1200.0
@export var lifetime: float = .1
@export var damage_tick_rate: float = 0.0 # 0 = single hit, >0 = continuous damage

var lighting_1 = preload("res://assets/sfx/gun_shots/Lightning_nuc_01.ogg")
var lighting_2 = preload("res://assets/sfx/gun_shots/Lightning_nuc_02.ogg")
var lighting_3 = preload("res://assets/sfx/gun_shots/Lightning_nuc_03.ogg")

@onready var lightnings = [lighting_1,lighting_2,lighting_3]
# -------------------------
# STATE
# -------------------------
var direction: Vector2 = Vector2.RIGHT
var bullet_owner: Node = null

# -------------------------
# NODES
# -------------------------
@onready var line_main: Line2D = $ln_laser_main
@onready var line_fallout: Line2D = $ln_laser_fallout
@onready var tmr_life: Timer = $tmr_life
@onready var tmr_damage: Timer = $tmr_damage
@onready var tmr_queue_free: Timer = $tmr_queue_free

var tween_main: Tween
var tween_fallout: Tween

# -------------------------
# READY
# -------------------------
func _ready() -> void:
	$asp_fire.stream = lightnings[randi_range(0,2)]
	$asp_fire.play()
	# Ray direction is fixed ONCE
	target_position = direction.normalized() * beam_length

	# Reset visuals
	line_main.points[1] = Vector2.ZERO
	line_fallout.points[1] = Vector2.ZERO

	# Lifetime
	tmr_life.wait_time = lifetime
	tmr_queue_free.wait_time = lifetime + 2
	tmr_life.start()

	_appear()

# -------------------------
# PHYSICS UPDATE
# -------------------------

	

func fire():
	force_raycast_update()

	var hit_point: Vector2 = target_position

	if is_colliding():
		$BeamParticles2D.amount = target_position.length()/10
		hit_point = to_local(get_collision_point())
		$CollisionParticles2D.position = hit_point
		$CastingParticles2D.position = Vector2.ZERO
		$CollisionParticles2D.emitting = true
		$CastingParticles2D.emitting = true
		_try_apply_damage(get_collider())

	line_main.points[1] = hit_point
	line_fallout.points[1] = hit_point

# -------------------------
# DAMAGE (OWNED BY BEAM)
# -------------------------
func _try_apply_damage(target: Object) -> void:
	if target == null:
		return

	if target == bullet_owner:
		return

	if target.has_method("take_damage"):
		target.take_damage(1)

# -------------------------
# VISUALS (TWEEN VIA CODE)
# -------------------------
func _appear() -> void:
	if tween_main:
		tween_main.kill()
	if tween_fallout:
		tween_fallout.kill()

	# FORCE a visible starting state
	line_main.width = 0.1
	line_fallout.width = 0.1

	tween_main = create_tween()
	tween_main.tween_property(line_main, "width", 4, lifetime)

	tween_fallout = create_tween()
	tween_fallout.tween_property(line_fallout, "width", 10, lifetime)



func _disappear() -> void:
	if tween_main:
		tween_main.kill()
	if tween_fallout:
		tween_fallout.kill()

	tween_main = create_tween()
	tween_main.tween_property(line_main, "width", 0, lifetime)

	tween_fallout = create_tween()
	tween_fallout.tween_property(line_fallout, "width", 0, lifetime)


func _on_tmr_life_timeout() -> void:
	_disappear()
	$tmr_queue_free.start()
	set_collision_mask(0)

	#global_collisions.set_all_mask_bits(self, false)


func _on_tmr_queue_free_timeout() -> void:
	queue_free()
