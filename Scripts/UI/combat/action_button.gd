class_name ActionButton
extends Button

signal action_button_pressed(action: ActionSelection)

var stored_action: ActionSelection

func _ready():
	pressed.connect(_on_pressed)


func _on_pressed():
	action_button_pressed.emit(stored_action)
	
