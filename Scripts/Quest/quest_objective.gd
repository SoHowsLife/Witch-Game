class_name QuestObjective

var data : QuestObjectiveData
var progress : int = 0
var completed : bool = false

func _init(objective_data: QuestObjectiveData):
	data = objective_data
