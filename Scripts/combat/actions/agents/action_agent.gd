class_name ActionAgent
extends RefCounted

enum AgentType {
	PLAYER_CONTROLLED = 0,
	RANDOM_SELECT = 0,
	RANDOM_TARGET_AND_SELECT = 0,
}

func get_input(battlefield_info: BattlefieldInfo, actor: Combatant):
	pass
