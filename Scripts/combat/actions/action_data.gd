class_name ActionData
extends Resource

@export_category("ID")
@export var action_id: ID.ActionID = ID.ActionID.None

@export_category("Basic Info")
@export var name: String = "Example Action"
@export var description: String = "Does a thing."
@export var category: ActionInstance.ActionType

@export_category("Action Info")
## Leave empty to ignore.
@export var attack: AttackData
## To be worked on.
@export var animation: bool
@export var target_type: ActionInstance.ActionTargetType
@export var effects: Array[Variant]
