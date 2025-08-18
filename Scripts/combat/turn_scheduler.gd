class_name TurnScheduler
extends Node

signal request_update

const MAX_FORESEEABLE_TURNS: int = 10

var _total_speed: float

var _schedule: Array[TurnSchedulerTask]


func advance_scheduler():
	pass


func sort_scheduler_queue():
	_schedule.sort_custom(TurnSchedulerTask.task_compare)
