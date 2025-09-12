class_name CombatStateMachine
extends Node3D

enum CombatState {
	SCHEDULER_IDLING,
	AWAITING_TURN_FINISH,
}

@export var log_debug: bool = false
@export var ally_combatants: Array[Combatant] = []
@export var enemy_combatants: Array[Combatant] = []

var state: CombatState = CombatState.SCHEDULER_IDLING

@onready var battlefield_info: BattlefieldInfo = BattlefieldInfo.new()
@onready var _scheduler: TurnScheduler = $"TurnScheduler"


func _ready() -> void:
	if log_debug:
		print("Initializing combat scene...")
		print(ally_combatants)
	init_combat()
	if log_debug:
		print("Combat scene initialized.")
	


func init_combat():
	for ally in ally_combatants:
		_scheduler.attach_to_scheduler(ally)
		ally.combatant_side = Combatant.CombatSide.PLAYER_SIDE
	battlefield_info.player_side = ally_combatants
	for enemy in enemy_combatants:
		_scheduler.attach_to_scheduler(enemy)
		enemy.combatant_side = Combatant.CombatSide.ENEMY_SIDE
	battlefield_info.enemy_side = enemy_combatants
	_scheduler.populate_scheduler(log_debug)
	if log_debug:
		_scheduler.print_attached_combatants()
		_scheduler.print_scheduler()
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
	combatant.tick_start_of_turn()
	var action: ActionInstance = combatant.get_action(battlefield_info)
	if action == null:
		push_error("Failed to retrieve action from ", combatant.entity_name, ".")
	else:
		process_action(action)
	combatant.tick_end_of_turn()


func process_action(action: ActionInstance):
	# Start Animation
	# Await Effect Signal from Animation
	# Process Effects
	if action.data.attack != null:
		pass
		# Do damage
		# Apply effects
	pass


func _on_turn_finish(combatant: Combatant):
	combatant.turn_finished.disconnect(_on_turn_finish)
	combatant.readd_ended_turn()
	_scheduler.sort_scheduler_queue()
	state = CombatState.SCHEDULER_IDLING
	state_update()
	pass
