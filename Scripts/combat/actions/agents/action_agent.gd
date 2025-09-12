class_name ActionAgent
extends RefCounted

enum AgentType {
	PLAYER_CONTROLLED,
	RANDOM_SELECT,
	RANDOM_SELECT_IGNORE_TEAM,
	SCRIPTED,
}

func get_input(battlefield_info: BattlefieldInfo, actor: Combatant) -> ActionInstance:
	return null
