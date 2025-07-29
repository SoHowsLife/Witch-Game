extends Resource

class_name QuestObjective

@export var type : QuestManager.ObjectiveType = QuestManager.ObjectiveType.COLLECT
@export var target : StringName = "Item"
@export var total : int = 1
var progress : int = 0
var completed : bool = false
