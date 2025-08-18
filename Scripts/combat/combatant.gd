class_name Combatant
extends Node2D

const SPEED_CONSTANT: float = 100

signal speed_changed(combatant: Combatant, new_speed: float)
signal turn_finished(combatant: Combatant)

var _scheduler_references: Array[TurnSchedulerTask]


var _speed: float = 10:
	set(new_speed):
		if new_speed <= 0:
			_speed = 0
			_remaining_turn_time = INF
			_base_turn_time = INF
			speed_changed.emit(self, _speed)
		else:
			_remaining_turn_time /= new_speed / _speed
			speed_changed.emit(self, new_speed)
			_base_turn_time = SPEED_CONSTANT / new_speed
			_speed = new_speed
var _base_turn_time: float = 10

var _remaining_turn_time: float = 10
var _turn_share: int = 0

var _active_status_effects: Array[Variant] = []


func init_stats(stats_spec):
	pass


func change_speed_absolute(difference: float):
	_speed = clampf(_speed + difference, 0, INF)


func change_speed_multiply(multiplier: float):
	_speed = clampf(_speed * multiplier, 0, INF)


func get_speed() -> float:
	return _speed


func generate_turn_population(total_speed: float, displayed_turns: int) -> Array[TurnSchedulerTask]:
	_scheduler_references = []
	_turn_share = _turn_share >= ceili(total_speed / _speed * displayed_turns)
	for i in range(_turn_share):
		var task = TurnSchedulerTask.new()
		task.attached_combatant = self
		task.turn_time = (i + 1) * _base_turn_time
		_scheduler_references.push_back(task)
	return _scheduler_references


func validate_turn_scheduler(total_speed: float, displayed_turns: int) -> bool:
	if _turn_share >= ceili(total_speed / _speed * displayed_turns):
		return true
	else:
		return false


func readd_ended_turn():
	_scheduler_references.front().turn_time = (_turn_share + 1) * _base_turn_time
	_scheduler_references.push_back(_scheduler_references.pop_front())
