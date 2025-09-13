class_name CombatFrontendHandler
extends Node3D

@export var background: Node
@export var audio_player: Node
@export var animator: Node

@onready var combat_menu: CombatControl = $"CombatMenu"

func handle_action_animation(action: ActionInstance):
	pass


func handle_damage_instance(damage: DamageInstance):
	pass


func handle_combatant_die(combatant: Combatant):
	pass


func handle_wait_player_control(battlefield_info: BattlefieldInfo, combatant: Combatant):
	combat_menu.init_control(battlefield_info, combatant)


func handle_turn_update(schedule: Array[TurnSchedulerTask]):
	pass
