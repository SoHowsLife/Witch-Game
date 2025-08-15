class_name TimedEffect
extends Node

var host: Combatant
var parameters: Array[Variant] = []
var turns_left: int = 0
var _start_of_turn_effect: Callable
var _end_of_turn_effect: Callable
var _expire_effect: Callable


func init_effect(initial_turns: int, carrier: Combatant, effect_params: Array[Variant]):
	turns_left = initial_turns
	host = carrier
	parameters = effect_params


func tick():
	turns_left -= 1
	if turns_left == 0:
		call_expire_effect()


func call_start_of_turn():
	if _start_of_turn_effect != null:
		_start_of_turn_effect.callv(parameters)


func call_end_of_turn():
	if _end_of_turn_effect != null:
		_end_of_turn_effect.callv(parameters)


func call_expire_effect():
	if _expire_effect != null:
		_expire_effect.callv(parameters)
