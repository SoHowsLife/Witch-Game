extends Resource

class_name Quest

@export var ID : ID.QuestID
@export var title : String = "Basic Quest"
@export var description : String = "A basic quest."
@export var objectives : Array[QuestObjective] = []
