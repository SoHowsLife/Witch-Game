class_name Interactable
extends CharacterBody3D

@export var id : ID.InteractionID = ID.InteractionID.None
@export var quest_to_give : ID.QuestID = ID.QuestID.None
@export var quest_to_complete : ID.QuestID = ID.QuestID.None

var dialogic_name : String

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func interact() -> void:
	QuestManager.interacted.emit(id)
	QuestManager.complete_quest(quest_to_complete)
	QuestManager.activate_quest(quest_to_give)
