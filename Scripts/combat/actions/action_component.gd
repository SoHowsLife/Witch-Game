class_name ActionComponent
extends Node

var possible_attacks: Array[ActionData]
var possible_supports: Array[ActionData]
var possible_other: Array[ActionData]

var _agent: ActionAgent


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


func init_actions(action_spread: ActionSpreadData):
	possible_attacks = action_spread.possible_attacks.duplicate()
	possible_supports = action_spread.possible_support.duplicate()
	possible_other = action_spread.possible_other.duplicate()


func ask_agent_input(battlefield_info: BattlefieldInfo, actor: Combatant) -> ActionInstance:
	return _agent.get_input(battlefield_info, actor)
