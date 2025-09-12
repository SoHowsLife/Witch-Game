extends Node

signal combat_initiate
signal combat_finish

signal combatant_exited_combat(id: ID.CombatantID)
signal action_used(instance: ActionInstance)

var active_combat_scene: CombatStateMachine
