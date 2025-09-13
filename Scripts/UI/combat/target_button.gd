class_name TargetButton
extends Button

signal target_button_pressed(targets: Array[Combatant])

var target_type: CombatRules.ActionTargetType
var stored_targets: Array[Combatant]

func _ready():
	pressed.connect(_on_pressed)


func _on_pressed():
	target_button_pressed.emit(stored_targets)
