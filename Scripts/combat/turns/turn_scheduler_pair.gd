class_name TurnSchedulerTask
extends Node


var turn_time: float
var attached_combatant: Combatant


static func task_compare(earlier: TurnSchedulerTask, later: TurnSchedulerTask) -> bool:
	return true if earlier.turn_time < later.turn_time else false


func get_print():
	return str(attached_combatant.entity_name, ": ", turn_time)
