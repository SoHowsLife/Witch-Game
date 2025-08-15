class_name TurnSchedulerTask
extends Node


var turn_time: float
var attached_combatant: float


static func task_compare(earlier: TurnSchedulerTask, later: TurnSchedulerTask) -> bool:
	return true if earlier.turn_time < later.turn_time else false
