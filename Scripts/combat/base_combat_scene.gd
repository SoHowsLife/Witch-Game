class_name CombatStateMachine
extends Node3D


enum CombatState {
	SCHEDULER_IDLING,
	AWAITING_TURN_FINISH,
}

var state: CombatState = CombatState.SCHEDULER_IDLING

var ally_combatants: Array[Combatant] = []
var enemy_combatants: Array[Combatant] = []

@onready var _scheduler: TurnScheduler = $"TurnScheduler"


func init_combat():
	for ally in ally_combatants:
		_scheduler.attach_to_scheduler(ally)
	for enemy in enemy_combatants:
		_scheduler.attach_to_scheduler(enemy)
	_scheduler.populate_scheduler()
	pass


func state_update():
	match(state):
		CombatState.SCHEDULER_IDLING:
			pass
			give_turn(_scheduler.advance_scheduler())
		CombatState.AWAITING_TURN_FINISH:
			push_warning("Tried to update combat state machine while waiting.")
	pass


func give_turn(combatant: Combatant):
	state = CombatState.AWAITING_TURN_FINISH
	combatant.turn_finished.connect(_on_turn_finish)
	pass


func _on_turn_finish(combatant: Combatant):
	combatant.turn_finished.disconnect(_on_turn_finish)
	combatant.readd_ended_turn()
	_scheduler.sort_scheduler_queue()
	state = CombatState.SCHEDULER_IDLING
	state_update()
	pass
