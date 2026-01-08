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
			return 50        # pistol / mg / uzi baseline
		AmmoType.SHOTGUN:
			return 25
		AmmoType.ENERGY:
			return 100       # energy units per "clip"
		AmmoType.EXPLOSIVE:
			return 20
		_:
			return 0
