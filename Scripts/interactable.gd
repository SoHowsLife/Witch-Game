class_name Interactable
extends CharacterBody3D

var dialogic_name : String

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func interact() -> void:
	print("Hi ", self)
	DialogueScreen.play_timeline("Test")
