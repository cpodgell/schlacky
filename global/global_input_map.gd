extends Node
class_name GlobalInputMap

var LEFT := "left"
var RIGHT := "right"
var JUMP := "A"
var ATTACK_1 := "X"
var ACTION := "B"
var RELOAD := "Y"
var SPECIAL := "L1"
var GRENADE := "R1"
var PICKUP_ITEM := "B"
var SWITCH_GUN_R := "dpad_right"
var SWITCH_GUN_L := "dpad_left"

static func action(player_index: int, name: String) -> String:
	return "p%d_%s" % [player_index, name]
