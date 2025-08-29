class_name ActionInstance
extends Node

enum ActionType {
	ATTACK,
	SUPPORT,
	OTHER,
}

enum ActionTargetType {
	SINGLE,
	SELF,
	SAME_SIDE_AOE,
	OPP_SIDE_AOE,
	BOTH_SIDE_AOE,
}
