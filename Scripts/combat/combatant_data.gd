class_name CombatantData
extends Resource

@export_group("Frontend")
@export var combatant_name: String = "Glorp"
@export var description: String = "Guh!"
@export var combat_sprite: Texture2D
@export var ui_sprite: Texture2D
@export_group("Backend")
@export var stat_spread: StatSpreadData
@export var action_spread: ActionSpreadData
@export var default_agent: ActionAgent.AgentType
