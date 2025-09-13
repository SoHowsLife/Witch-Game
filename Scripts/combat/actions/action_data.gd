class_name ActionData
extends Resource

@export_category("ID")
@export var action_id: ID.ActionID = ID.ActionID.None

@export_category("Basic Info")
@export var name: String = "Example Action"
@export var description: String = "Does a thing."
@export var category: CombatRules.ActionType

@export_category("Action Info")
## Leave empty to ignore.
@export var attack: AttackData
## To be worked on.
@export var animation: bool
@export var target_type: CombatRules.ActionTargetType
@export var effects: Array[Variant]
@export var initial_cooldown: int = 0
@export var cooldown_after_use: int = 0
