extends Node

enum Elements {
	FIRE,
	WATER,
	AIR,
	EARTH,
	ICE,
	LIGHTNING,
	POISON,
}


func get_level_scaled_stat(base_stat: float, level: float, level_factor: float,
		mult_every_x: float = 10) -> float:
	var level_multiplier = pow(level_factor, level / mult_every_x)
	return base_stat * level_multiplier
