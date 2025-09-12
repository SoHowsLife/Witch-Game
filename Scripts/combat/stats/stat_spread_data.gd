class_name StatSpreadData
extends Resource

@export_group("Base")
@export var base_HP: float = 100
@export var base_ATK: float = 10
@export var base_DEF: float = 10
@export var base_SPD: float = 10

@export_group("Scaling")
@export var base_HP_scaling_factor: float = 2
@export var base_ATK_scaling_factor: float = 2
@export var base_DEF_scaling_factor: float = 2
@export var base_SPD_scaling_factor: float = 1.2

@export_group("Other")
@export var base_resistances: ElementalSpreadData
@export var added_crit_chance: float = 0
@export var added_crit_multiplier: float = 0
