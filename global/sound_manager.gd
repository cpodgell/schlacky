extends Node
class_name SoundManager

# --- Stream paths (edit if your paths differ) ---
const PISTOL_PATH := "res://assets/sfx/gun_shots/pistol.ogg"
const SHOTGUN_PATH := "res://assets/sfx/gun_shots/pistol_01.ogg"
const UZI_PATH := "res://assets/sfx/gun_shots/gun_submachine_silenced_shot_0_first.wav"
const RELOAD_SHOTGUN_PATH := "res://assets/sfx/misc/shotgun_cock.ogg"
const GUN_CYCLE_PATH := "res://assets/sfx/misc/gun_cycle_2.ogg"
const DRY_FIRE_PATH := "res://assets/sfx/foly/dry_fire_01.wav"
const RELOAD2_PATH := "res://assets/sfx/gun_shots/gun_semi_auto_rifle_magazine_load_03.wav"
const ROCKET_PATH := "res://assets/sfx/gun_shots/rocket_launcher_shot_01.wav"

# --- Streams (loaded once) ---
var pistol: AudioStream
var shotgun: AudioStream
var uzi: AudioStream
var reload_shotgun: AudioStream
var gun_cycle: AudioStream
var dry_fire: AudioStream
var reload2: AudioStream
var rocket: AudioStream

# --- Players (created at runtime) ---
var _p_pistol: AudioStreamPlayer
var _p_shotgun: AudioStreamPlayer
var _p_uzi: AudioStreamPlayer
var _p_reload_shotgun: AudioStreamPlayer
var _p_gun_cycle: AudioStreamPlayer
var _p_dry_fire: AudioStreamPlayer
var _p_reload2: AudioStreamPlayer
var _p_rocket: AudioStreamPlayer


func _ready() -> void:
	# Load streams once (autoload lifetime)
	pistol = load(PISTOL_PATH) as AudioStream
	shotgun = load(SHOTGUN_PATH) as AudioStream
	uzi = load(UZI_PATH) as AudioStream
	reload_shotgun = load(RELOAD_SHOTGUN_PATH) as AudioStream
	gun_cycle = load(GUN_CYCLE_PATH) as AudioStream
	dry_fire = load(DRY_FIRE_PATH) as AudioStream
	reload2 = load(RELOAD2_PATH) as AudioStream
	rocket = load(ROCKET_PATH) as AudioStream

	# Create players once
	_p_pistol = _make_player(pistol)
	_p_shotgun = _make_player(shotgun)
	_p_uzi = _make_player(uzi)
	_p_reload_shotgun = _make_player(reload_shotgun)
	_p_gun_cycle = _make_player(gun_cycle)
	_p_dry_fire = _make_player(dry_fire)
	_p_reload2 = _make_player(reload2)
	_p_rocket = _make_player(rocket)


func _make_player(stream: AudioStream) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.stream = stream
	add_child(p)
	return p


# --- Play API (what you asked for) ---
func play_pistol(restart := false) -> void:
	_play(_p_pistol, restart)

func play_shotgun(restart := false) -> void:
	_play(_p_shotgun, restart)

func play_uzi(restart := false) -> void:
	_play(_p_uzi, restart)

func play_reload_shotgun(restart := false) -> void:
	_play(_p_reload_shotgun, restart)

func play_gun_cycle(restart := false) -> void:
	_play(_p_gun_cycle, restart)

func play_dry_fire(restart := false) -> void:
	_play(_p_dry_fire, restart)

func play_reload2(restart := false) -> void:
	_play(_p_reload2, restart)

func play_rocket(restart := false) -> void:
	_play(_p_rocket, restart)


func _play(p: AudioStreamPlayer, restart: bool) -> void:
	if p == null or p.stream == null:
		return
	if restart and p.playing:
		p.stop()
	p.play()
