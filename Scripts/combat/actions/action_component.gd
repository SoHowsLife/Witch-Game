class_name ActionComponent
extends Node

var possible_attacks: Array[ActionData]
var possible_supports: Array[ActionData]
var possible_other: Array[ActionData]


func init_actions(action_spread: ActionSpreadData):
	possible_attacks = action_spread.possible_attacks.duplicate()
	possible_supports = action_spread.possible_support.duplicate()
	possible_other = action_spread.possible_other.duplicate()


func request_agent_input():
	pass
