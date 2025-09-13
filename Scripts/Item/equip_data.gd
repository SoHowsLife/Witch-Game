extends Resource

class_name EquipData

@export_category("Player Stats")
## Alters player max health
@export var max_health : int = 0 
## Alters player defense
@export var defense : int = 0 
## Alters raw player attack damage
@export var attack : int = 0 
## Multiplies player attack damage
@export var attack_mult : float = 1.0

@export_category("Unique Effects")
## Reflects damage back to enemy
@export var thorns_mult : float = 0.0
