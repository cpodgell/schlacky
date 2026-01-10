extends Node
class_name GameDefs

enum WeaponType {
	NONE,
	PISTOL,
	SHOTGUN,
	MACHINE_GUN,
	UZI,
	LASER,
	ROCKET_LAUNCHER
}

enum AmmoType {
	NONE,
	BULLETS,
	SHOTGUN,
	ENERGY,
	EXPLOSIVE
}

static func get_ammo_type(weapon_type: WeaponType) -> AmmoType:
	match weapon_type:
		WeaponType.PISTOL:
			return AmmoType.BULLETS

		WeaponType.MACHINE_GUN:
			return AmmoType.BULLETS

		WeaponType.UZI:
			return AmmoType.BULLETS

		WeaponType.SHOTGUN:
			return AmmoType.SHOTGUN

		WeaponType.LASER:
			return AmmoType.ENERGY

		WeaponType.ROCKET_LAUNCHER:
			return AmmoType.EXPLOSIVE

		_:
			return AmmoType.BULLETS # safe default / NONE

static func get_total_size(ammo_type: AmmoType) -> int:
	match ammo_type:
		AmmoType.BULLETS:
			return 235        # pistol / mg / uzi baseline
		AmmoType.SHOTGUN:
			return 50
		AmmoType.ENERGY:
			return 100       # energy units per "clip"
		AmmoType.EXPLOSIVE:
			return 35
		_:
			return 0

static func get_clip_size(weapon_type: WeaponType) -> int:
	match weapon_type:
		WeaponType.PISTOL: return 12
		WeaponType.MACHINE_GUN: return 35
		WeaponType.UZI: return 50
		WeaponType.SHOTGUN: return 5
		WeaponType.LASER: return 8
		WeaponType.ROCKET_LAUNCHER: return 1
		_:
			return 0 # <-- NOT AmmoType.BULLETS
