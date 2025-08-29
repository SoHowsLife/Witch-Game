class_name ElementalSpreadData
extends Resource

## Resists are split into different variables for resource editability.

@export_group("Elemental Multipliers")
@export_range(-3.0, 3.0, 0.05) var fire: float
@export_range(-3.0, 3.0, 0.05) var water: float
@export_range(-3.0, 3.0, 0.05) var air: float
@export_range(-3.0, 3.0, 0.05) var earth: float
@export_range(-3.0, 3.0, 0.05) var ice: float
@export_range(-3.0, 3.0, 0.05) var lightning: float
@export_range(-3.0, 3.0, 0.05) var poison: float

var _elemental_spread: Array[float]

func _init():
	_elemental_spread = [
		fire,
		water,
		air,
		earth,
		ice,
		lightning,
		poison,
	]

func get_element_multiplier(element: CombatRules.Elements):
	return _elemental_spread[element]
