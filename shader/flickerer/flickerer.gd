class_name Flickerer
extends Node

@onready var tmr := $tmr_flicker_length

var base_material: ShaderMaterial
var base_shader: Shader

var targets: Array[Sprite2D] = []
var mats: Array[ShaderMaterial] = []

func initialize(root: Node):
	tmr.wait_time = 0.1
	tmr.one_shot = true

	base_material = load("res://shader/flickerer/white_flicker_material2.tres")
	base_shader   = load("res://shader/flickerer/white_flicker_shader.gdshader")

	if base_material == null: push_error("Failed to load material.")
	if base_shader == null: push_error("Failed to load shader.")

	base_material.resource_local_to_scene = true
	base_shader.resource_local_to_scene = true

	targets.clear()
	mats.clear()
	_collect_sprites(root)

	for s in targets:
		var m := base_material.duplicate(true) as ShaderMaterial
		m.shader = base_shader
		m.set_shader_parameter("whitening", 0.0)
		s.material = m
		mats.append(m)

func _collect_sprites(n: Node) -> void:
	if n is Sprite2D:
		targets.append(n)
	for c in n.get_children():
		_collect_sprites(c)

func disable_flickerer():
	$tmr_flicker_length.stop()
	for s in targets:
		s.material = null

func flicker():
	for m in mats:
		m.set_shader_parameter("whitening", 1.0)
	tmr.start()

func _on_tmr_flicker_length_timeout():
	for m in mats:
		m.set_shader_parameter("whitening", 0.0)
