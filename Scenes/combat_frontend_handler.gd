class_name CombatFrontendHandler
extends Node3D

@export var background: Node
@export var audio_player: Node
@export var animator: Node


func handle_action_animation(action: ActionInstance):
	pass


func handle_damage_instance(damage: DamageInstance):
	pass


func handle_combatant_die(combatant: Combatant):
	pass


func handle_wait_player_control(combatant: Combatant):
	
	pass


func handle_turn_update(schedule: Array[TurnSchedulerTask]):
	pass
