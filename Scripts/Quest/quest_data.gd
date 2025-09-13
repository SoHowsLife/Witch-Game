extends Resource

class_name QuestData

@export var quest_ID : ID.QuestID
@export var title : String = "Basic Quest"
@export var description : String = "A basic quest."
@export var objectives : Array[QuestObjectiveData] = []
@export var recurring : bool = false
