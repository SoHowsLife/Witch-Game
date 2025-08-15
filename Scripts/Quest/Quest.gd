extends Resource

class_name Quest

@export var quest_id : ID.QuestID
@export var title : String = "Basic Quest"
@export var description : String = "A basic quest."
@export var objectives : Array[QuestObjective] = []
