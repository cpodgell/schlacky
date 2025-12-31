extends Node
class_name GlobalInputMap

const LEFT := "left"
const RIGHT := "right"
const JUMP := "A"
const ATTACK_1 := "X"
const ACTION := "B"
const RELOAD := "Y"
const SPECIAL := "L1"

static func action(player_index: int, name: String) -> String:
	return "p%d_%s" % [player_index, name]
