extends Resource

class_name Quest

@export var title : String = "Basic Quest"
@export var description : String = "A basic quest."
@export var objectives : Array[QuestObjective] = []

var path : String
