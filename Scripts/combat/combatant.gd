class_name Combatant
extends Node2D

signal speed_changed(new_speed: float)
signal turn_finished(combatant: Combatant)

var _scheduler_references: Array[TurnSchedulerTask]


var _health: int = 0
var _max_health: int = 0

var _attack: int = 0
var _defense: int = 0

var _speed: float = 10:
	set(new_speed):
		_speed = new_speed
		speed_changed.emit(new_speed)
		_base_action_value = 0
var _base_action_value: float = 10

var _active_buffs: Array[Variant] = []
var _active_debuffs: Array[Variant] = []


func init_stats(stats_spec):
	pass


func change_speed_absolute(difference: float):
	_speed = clampf(_speed + difference, 0, INF)


func change_speed_multiply(multiplier: float):
	_speed = clampf(_speed * multiplier, 0, INF)


func get_speed() -> float:
	return _speed


func populate_turn_scheduler():
	var max_turns_foreseeable = floori(TurnScheduler.MAX_FORESEEABLE_ACTION_VALUE)
