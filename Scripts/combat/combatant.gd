class_name Combatant
extends Node3D

const SPEED_CONSTANT: float = 100

signal speed_changed(combatant: Combatant, new_speed: float)
signal turn_moved(combatant: Combatant)
signal turn_finished(combatant: Combatant)
signal turns_added(task: Array[TurnSchedulerTask])
signal turns_removed(task: Array[TurnSchedulerTask])

@export_group("Meta")
@export var combatant_template: CombatantData
@export_group("Combat Info")
@export var entity_name: String = "Guh"
@export var description: String = "Buh."


var speed: float:
	get:
		return stats.effective_SPD

var _scheduler_references: Array[TurnSchedulerTask]
var _base_turn_time: float = 10
var _remaining_turn_time:
	get():
		return _scheduler_references.front().turn_time
var _turn_share: int = 0

@onready var stats = $"StatsComponent" as StatsComponent
@onready var effects = $"EffectsComponent" as EffectsComponent
@onready var _debug_namesign = str(entity_name, ": ")

func _ready() -> void:
	if combatant_template:
		init_stats(combatant_template)
	stats.speed_changed.connect(_on_stats_speed_changed)
	pass


func init_stats(stats_spec: CombatantData):
	stats.init_stats(stats_spec.stat_spread)
	pass


func generate_turn_population(total_speed: float, displayed_turns: int, log_debug: bool) -> bool:
	_scheduler_references = []
	_turn_share = ceili(speed / total_speed * displayed_turns)
	if log_debug:
		print(_debug_namesign, "Calculated turn share = ", _turn_share)
	for i in range(_turn_share):
		var task = TurnSchedulerTask.new()
		task.attached_combatant = self
		task.turn_time = (i + 1) * _base_turn_time
		_scheduler_references.push_back(task)
	turns_added.emit(_scheduler_references)
	if log_debug:
		print(_debug_namesign, "Made scheduler turns = ", _scheduler_references)
	return true


func validate_turn_scheduler(total_speed: float, displayed_turns: int) -> bool:
	if _scheduler_references.is_empty():
		push_warning("Tried to validate empty turns: ", self)
		return false

	var new_turn_share = ceili(speed / total_speed * displayed_turns)
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


func receive_turn():
	pass


## Moves all of this combatant's turns by time proportional to BTT and [param multiplier].
## Effective domain [-INF, 1], where a negative value delays turns.
func move_turn_by_percent(multiplier: float):
	var movement := clampf(_base_turn_time * multiplier, -INF, _remaining_turn_time)
	for turn in _scheduler_references:
		turn.turn_time -= movement
	turn_moved.emit(self)


func _on_stats_speed_changed(new_speed: float, old_speed: float):
	if new_speed <= 0:
		for turn in _scheduler_references:
			turn.turn_time = INF
		_base_turn_time = INF
		speed_changed.emit(self, new_speed)
	else:
		for turn in _scheduler_references:
			turn.turn_time /= new_speed / old_speed
		_base_turn_time = SPEED_CONSTANT / new_speed
		speed_changed.emit(self, new_speed)
