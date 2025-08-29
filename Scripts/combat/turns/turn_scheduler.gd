class_name TurnScheduler
extends Node

signal request_update

const MAX_FORESEEABLE_TURNS: int = 10

var _total_speed: float

var _schedule: Array[TurnSchedulerTask]
var _attached_combatants: Array[Combatant]



func advance_scheduler() -> Combatant:
	for turn in _schedule:
		turn.turn_time -= _schedule.front().turn_time
	return _schedule.front().attached_combatant


func populate_scheduler():
	var new_tspd = _get_tspd()
	for combatant in _attached_combatants:
		combatant.generate_turn_population(new_tspd, MAX_FORESEEABLE_TURNS)


func validate_scheduler():
	var new_tspd = _get_tspd()
	for combatant in _attached_combatants:
		combatant.validate_turn_scheduler(new_tspd, MAX_FORESEEABLE_TURNS)


func attach_to_scheduler(combatant: Combatant):
	_attached_combatants.push_back(combatant)
	combatant.turns_added.connect(_on_request_add_turns)
	combatant.turns_removed.connect(_on_request_remove_turns)
	combatant.speed_changed.connect(_on_combatant_speed_changed)
	combatant.turn_moved.connect(_on_combatant_turn_moved)


func detach_from_scheduler(combatant: Combatant):
	_attached_combatants.erase(combatant)
	combatant.turns_added.disconnect(_on_request_add_turns)
	combatant.turns_removed.disconnect(_on_request_remove_turns)
	combatant.speed_changed.disconnect(_on_combatant_speed_changed)
	combatant.turn_moved.disconnect(_on_combatant_turn_moved)


func sort_scheduler_queue():
	_schedule.sort_custom(TurnSchedulerTask.task_compare)


func _on_combatant_speed_changed(_combatant: Combatant, _speed: float):
	var new_tspd = _get_tspd()
	for combatant in _attached_combatants:
		combatant.validate_turn_scheduler(new_tspd, MAX_FORESEEABLE_TURNS)
	sort_scheduler_queue()


func _on_combatant_turn_moved():
	sort_scheduler_queue()


func _on_request_add_turns(added_turns: Array[TurnSchedulerTask]):
	for turn in added_turns:
		_schedule.push_back(turn)
	sort_scheduler_queue()


func _on_request_remove_turns(removed_turns: Array[TurnSchedulerTask]):
	for turn in removed_turns:
		_schedule.erase(turn)


func _get_tspd() -> int:
	var total := 0
	for combatant in _attached_combatants:
		total += combatant.get_speed()
	return total
