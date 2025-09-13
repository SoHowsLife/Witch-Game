extends Resource

class_name EquipData

@export_category("Attack Stats")
@export var attack : float = 0
@export var elemental_penetration : ElementalSpreadData
@export var critical_hit_chance : float = 0
@export var critical_multiplier : float = 0

@export_category("Defense Stats")
@export var health : float = 0 
@export var defense : float = 0
@export var elemental_resistance : ElementalSpreadData

@export_category("Unique Effects")
@export var item_behavior_script : GDScript
