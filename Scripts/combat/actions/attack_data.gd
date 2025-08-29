class_name AttackData
extends Resource

@export_range(0, 200, 1.0, "or_greater") var power: int
@export var element: CombatRules.Elements
@export_range(0, 1, 0.01) var critical_hit_chance: float
@export_range(0.0, 3.0, 0.01, "or_greater", "or_less") var crit_multiplier: float
