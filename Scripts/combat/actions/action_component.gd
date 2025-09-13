class_name ActionComponent
extends Node


var possible_attacks: Array[ActionSelection]
var possible_supports: Array[ActionSelection]
var possible_other: Array[ActionSelection]

var _agent: ActionAgent


# cooldowns

func init_agent(agent_type: ActionAgent.AgentType = ActionAgent.AgentType.RANDOM_SELECT):
	match(agent_type):
		ActionAgent.AgentType.PLAYER_CONTROLLED:
			_agent = AgentPlayerControlled.new()
		ActionAgent.AgentType.RANDOM_SELECT:
			_agent = AgentRandomSelect.new()
		ActionAgent.AgentType.RANDOM_SELECT_IGNORE_TEAM:
			_agent = AgentTrueRandomSelect.new()
		ActionAgent.AgentType.SCRIPTED:
			pass
		_:
			push_error("Bad agent type.")
			_agent = ActionAgent.new()


func init_actions(action_spread: ActionSpreadData):
	possible_attacks = []
	possible_supports = []
	possible_other = []
	for attack in action_spread.possible_attacks:
		var attack_selection = ActionSelection.new()
		attack_selection.action_data = attack
		attack_selection.cooldown = attack.initial_cooldown
		attack_selection.max_cooldown = attack.cooldown_after_use
		possible_attacks.push_back(attack_selection)
	for support in action_spread.possible_supports:
		var support_selection = ActionSelection.new()
		support_selection.action_data = support
		support_selection.cooldown = support.initial_cooldown
		support_selection.max_cooldown = support.cooldown_after_use
		possible_supports.push_back(support_selection)
	for other in action_spread.possible_others:
		var other_selection = ActionSelection.new()
		other_selection.action_data = other
		other_selection.cooldown = other.initial_cooldown
		other_selection.max_cooldown = other.cooldown_after_use
		possible_other.push_back(other_selection)


func ask_agent_input(battlefield_info: BattlefieldInfo, actor: Combatant) -> ActionInstance:
	return _agent.get_input(battlefield_info, actor)
