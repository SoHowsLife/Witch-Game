extends Node

signal combat_initiate
signal combat_finish

signal tracking_combatant_exited_combat(id: ID.CombatantID)
signal tracking_action_used(userID: ID.CombatantID, instance: ActionInstance)

var active_combat_scene: CombatStateMachine

func initiate_combat(encounter_data: EncounterData):
	pass
