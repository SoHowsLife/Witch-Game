class_name Combatant
extends Node2D

signal speed_changed(new_speed: float)
signal turn_finished(combatant: Combatant)

var _scheduler_references: Array[TurnSchedulerPair]


var _speed: float = 100
var _action_value: float = 0

var _active_buffs: Array[Variant] = []
var _active_debuffs: Array[Variant] = []




func init_stats(stats_spec):
	pass


func change_speed_absolute(difference: float):
	pass


func change_speed_multiply(multiplier: float):
	pass
