class_name ActionAgent
extends RefCounted

enum AgentType {
	PLAYER_CONTROLLED,
	RANDOM_SELECT,
	RANDOM_TARGET_AND_SELECT,
}

func get_input(battlefield_info: BattlefieldInfo, actor: Combatant):
	pass
