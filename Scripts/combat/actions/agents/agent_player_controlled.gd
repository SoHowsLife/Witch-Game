class_name AgentPlayerControlled
extends ActionAgent


func get_input(battlefield_info: BattlefieldInfo, actor: Combatant):
	CombatManager.request_player_input_action.emit(actor)
	return await CombatManager.return_player_input_action
