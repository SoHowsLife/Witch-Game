class_name TurnScheduler
extends Node

signal request_update

const MAX_FORESEEABLE_ACTION_VALUE = 50

var _schedule: Array[TurnSchedulerTask]


func advance_scheduler():
	pass


func sort_scheduler_queue():
	_schedule.sort_custom(TurnSchedulerTask.task_compare)
