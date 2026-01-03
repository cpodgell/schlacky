class_name Sprite_Body extends Node2D

signal animation_finished(current_anim)
signal flip_triggered

@export var char_class_name = ""

var backwards : bool = false

var dfr = 1
var current_state 
var anp_player  : AnimationPlayer

var initial_hat_frame = 0
var max_hats = 0

enum states { NONE, WALK, IDLE, DEAD, DISABLED, INJURE, CROUCH_WALK, CROUCH_IDLE }

func get_custom_class():
	return "Sprite_Body"

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_hat_frame = $hat/spr_hats.frame
	max_hats = $hat/spr_hats.hframes * $hat/spr_hats.vframes
	play_idle()

	anp_player = $AnimationPlayer
	anp_player.connect("animation_finished", Callable(self, "_on_AnimationPlayer_animation_finished") )

func play_idle():
	if(current_state != states.IDLE):
		current_state = states.IDLE
		$hat/spr_hats.frame = initial_hat_frame
		play_anim('Idle')

func play_walk(tmp_backwards = false):
	if(current_state != states.WALK or tmp_backwards != backwards):
		backwards = tmp_backwards
		current_state = states.WALK
		$hat/spr_hats.frame = initial_hat_frame + 1
		if(backwards):
			play_anim_backwards('Walk')
		else:
			play_anim('Walk')

func play_crouch_walk(tmp_backwards = false):
	if(current_state != states.CROUCH_WALK or tmp_backwards != backwards):
		backwards = tmp_backwards
		current_state = states.CROUCH_WALK
		if(backwards):
			play_anim_backwards('crouch_walk')
		else:
			play_anim('crouch_walk')

func play_crouch_idle(tmp_backwards = false):
	if(current_state != states.CROUCH_IDLE or tmp_backwards != backwards):
		backwards = tmp_backwards
		current_state = states.CROUCH_IDLE
		if(backwards):
			play_anim_backwards('crouch_idle')
		else:
			play_anim('crouch_idle')

func play_dead():
	if(current_state != states.DEAD):
		current_state = states.DEAD
		play_anim('Dead')

func set_color(_mod_color : Color):
	$spr_schlacky.modulate = _mod_color

func play_disabled():
	if(current_state != states.DISABLED):
		current_state = states.DISABLED
		play_anim('Disabled')

func play_injure():
	current_state = states.INJURE
	play_anim('Injure')

func play_anim(tmp_anim, tmp_frame_rate = null):
	if(anp_player != null):
		if(tmp_frame_rate != null):
			anp_player.speed_scale = tmp_frame_rate
		else:
			anp_player.speed_scale = dfr
		anp_player.play(tmp_anim)

func play_anim_backwards(tmp_anim, tmp_frame_rate = null):
	if(tmp_frame_rate != null):
		anp_player.speed_scale = tmp_frame_rate
	else:
		anp_player.speed_scale = dfr
	anp_player.play_backwards(tmp_anim)

func increase_hat():
	if(current_state == states.IDLE):
		initial_hat_frame += 2
		if(initial_hat_frame > max_hats):
			initial_hat_frame = 0
	if(current_state == states.WALK):
		initial_hat_frame += 1
	$hat/spr_hats.frame = initial_hat_frame

func decrease_hat():
	if(current_state == states.IDLE):
		initial_hat_frame -= 2
		if(initial_hat_frame < 0):
			initial_hat_frame = max_hats
	if(current_state == states.WALK):
		initial_hat_frame -= 1
	$hat/spr_hats.frame = initial_hat_frame

func attack_1_triggered():
	emit_signal("attack_1_triggered")

func flip(tmp_x):
	self.scale.x = tmp_x

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_Q):
		decrease_hat()
	if Input.is_key_pressed(KEY_E):
		increase_hat()

func place_hat_at_stand():
	$hat/spr_hats.position = $mrk_stand.position

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)
