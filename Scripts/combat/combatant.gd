class_name Combatant
extends Node2D

const SPEED_CONSTANT: float = 100

signal speed_changed(combatant: Combatant, new_speed: float)
signal turn_moved(combatant: Combatant)
signal turn_finished(combatant: Combatant)
signal turns_added(task: Array[TurnSchedulerTask])
signal turns_removed(task: Array[TurnSchedulerTask])

var _scheduler_references: Array[TurnSchedulerTask]
var _speed: float = 10:
	set(new_speed):
		if new_speed <= 0:
			_speed = 0
			for turn in _scheduler_references:
				turn.turn_time = INF
			_base_turn_time = INF
			speed_changed.emit(self, _speed)
		else:
			for turn in _scheduler_references:
				turn.turn_time /= new_speed / _speed
			_base_turn_time = SPEED_CONSTANT / new_speed
			_speed = new_speed
			speed_changed.emit(self, _speed)
var _base_turn_time: float = 10
var _remaining_turn_time:
	get():
		return _scheduler_references.front().turn_time
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


func generate_turn_population(total_speed: float, displayed_turns: int) -> bool:
	_scheduler_references = []
	_turn_share = _turn_share >= ceili(total_speed / _speed * displayed_turns)
	for i in range(_turn_share):
		var task = TurnSchedulerTask.new()
		task.attached_combatant = self
		task.turn_time = (i + 1) * _base_turn_time
		_scheduler_references.push_back(task)
	turns_added.emit(_scheduler_references)
	return true


func validate_turn_scheduler(total_speed: float, displayed_turns: int) -> bool:
	if _scheduler_references.is_empty():
		push_warning("Tried to validate empty turns: ", self)
		return false

	var new_turn_share = ceili(total_speed / _speed * displayed_turns)
	if _turn_share == new_turn_share:
		return true
	elif _turn_share < new_turn_share:
		var remainder_constant = _remaining_turn_time
		var new_turns: Array[TurnSchedulerTask] = []
		for i in range(new_turn_share - _turn_share):
			var task = TurnSchedulerTask.new()
			task.attached_combatant = self
			task.turn_time = (_turn_share + i + 1) * _base_turn_time + remainder_constant
			_scheduler_references.push_back(task)
			new_turns.push_back(task)
		turns_added.emit(new_turns)
		return true
	else:
		var removed_turns: Array[TurnSchedulerTask] = []
		for i in range(_turn_share - new_turn_share):
			removed_turns.push_back(_scheduler_references.pop_back())
		turns_removed.emit(removed_turns)
		return true


func readd_ended_turn():
	_scheduler_references.front().turn_time = (_turn_share + 1) * _base_turn_time
	_scheduler_references.push_back(_scheduler_references.pop_front())


## Moves all of this combatant's turns by time proportional to BTT and [param multiplier].
## Effective domain [-INF, 1], where a negative value delays turns.
func move_turn_by_percent(multiplier: float):
	var movement := clampf(_base_turn_time * multiplier, -INF, _remaining_turn_time)
	for turn in _scheduler_references:
		turn.turn_time -= movement
	turn_moved.emit(self)
