class_name Interactable
extends CharacterBody3D

@export var id : ID.InteractionID

var dialogic_name : String

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func interact() -> void:
	QuestManager.interacted.emit(id)
