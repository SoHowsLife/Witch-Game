class_name CombatStateMachine
extends Node2D

enum CombatState {
	SCHEDULER_IDLING,
	AWAITING_TURN_FINISH,
}

var state: CombatState = CombatState.SCHEDULER_IDLING

var ally_combatants: Array[Combatant] = []
var enemy_combatants: Array[Combatant] = []


func init_combat():
	pass


func give_turn(combatant: Combatant):
	state = CombatState.AWAITING_TURN_FINISH
	combatant.turn_finished.connect(_on_turn_finish)
	pass


func _on_turn_finish(combatant: Combatant):
	combatant.turn_finished.disconnect(_on_turn_finish)
	pass
