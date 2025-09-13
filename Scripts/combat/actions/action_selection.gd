class_name ActionSelection
extends RefCounted

var cooldown: int = 0
var max_cooldown: int = 2
var action_data: ActionData


func decrement_cd():
	cooldown = clampi(cooldown - 1, 0, max_cooldown)


func get_action_selection():
	return self


func use(user: Combatant, receivers: Array[Combatant]) -> ActionInstance:
	cooldown = max_cooldown
	var action = ActionInstance.new()
	action.actor = user
	action.receivers = receivers
	action.data = action_data
	return action


## Returns a nested array of target selections
func get_possible_targets(battlefield_info: BattlefieldInfo, user: Combatant, 
		user_side: CombatRules.CombatSide):
	var possible_targets = []
	match(action_data.target_type):
		CombatRules.ActionTargetType.SINGLE:
			for target in battlefield_info.player_side:
				possible_targets.push_back([target])
			for target in battlefield_info.enemy_side:
				possible_targets.push_back([target])
		CombatRules.ActionTargetType.SINGLE_SAME_SIDE:
			if user_side == CombatRules.CombatSide.PLAYER_SIDE:
				for target in battlefield_info.player_side:
					possible_targets.push_back([target])
			else:
				for target in battlefield_info.enemy_side:
					possible_targets.push_back([target])
		CombatRules.ActionTargetType.SINGLE_OPP_SIDE:
			if user_side == CombatRules.CombatSide.PLAYER_SIDE:
				for target in battlefield_info.enemy_side:
					possible_targets.push_back([target])
			else:
				for target in battlefield_info.player_side:
					possible_targets.push_back([target])
		CombatRules.ActionTargetType.SELF:
			possible_targets.push_back([user])
		CombatRules.ActionTargetType.AOE_SAME_SIDE:
			if user_side == CombatRules.CombatSide.PLAYER_SIDE:
				possible_targets.push_back(battlefield_info.player_side.duplicate())
			else:
				possible_targets.push_back(battlefield_info.enemy_side.duplicate())
		CombatRules.ActionTargetType.AOE_OPP_SIDE:
			if user_side == CombatRules.CombatSide.PLAYER_SIDE:
				possible_targets.push_back(battlefield_info.enemy_side.duplicate())
			else:
				possible_targets.push_back(battlefield_info.player_side.duplicate())
		CombatRules.ActionTargetType.AOE_BOTH_SIDE:
			possible_targets.push_back(battlefield_info.player_side.duplicate())
			possible_targets.push_back(battlefield_info.enemy_side.duplicate())
		_:
			push_error("Bad user side for target selection.")
	return possible_targets
	
	
