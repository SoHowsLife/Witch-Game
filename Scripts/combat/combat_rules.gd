extends Node

const DEFAULT_LEVEL_SCALE_FACTOR: float = 2
const DEFAULT_MULT_EVERY_X: float = 10

enum Elements {
	FIRE,
	WATER,
	AIR,
	EARTH,
	ICE,
	LIGHTNING,
	POISON,
}


func get_level_scaled_stat(base_stat: float, level: float, level_factor: float = DEFAULT_LEVEL_SCALE_FACTOR,
		mult_every_x: float = DEFAULT_MULT_EVERY_X) -> float:
	var level_multiplier = pow(level_factor, level / mult_every_x)
	return base_stat * level_multiplier
