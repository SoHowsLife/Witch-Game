class_name ActionComponent
extends Node

var actor: Combatant

var possible_attacks: Array[ActionData]
var possible_supports: Array[ActionData]
var possible_other: Array[ActionData]

var _agent: ActionAgent


func init_actions(action_spread: ActionSpreadData):
	possible_attacks = action_spread.possible_attacks.duplicate()
	possible_supports = action_spread.possible_support.duplicate()
	possible_other = action_spread.possible_other.duplicate()


func ask_agent_input(actor: ActionComponent) -> ActionInstance:
	return null
