class_name AgentRandomSelect
extends ActionAgent


func get_input(battlefield_info: BattlefieldInfo, actor: Combatant):
	# Assume uniform distribution for now
	var action_pool = [] as Array[ActionSelection]
	action_pool.append_array(actor.actions.possible_attacks)
	action_pool.append_array(actor.actions.possible_supports)
	action_pool.append_array(actor.actions.possible_other)
	
	var select = randi_range(0, action_pool.size() - 1)
	var action = action_pool[select]
	var targets = action.get_possible_targets(battlefield_info, actor, actor.combatant_side)
	return action.use(actor, targets[randi_range(0, targets.size() - 1)])
