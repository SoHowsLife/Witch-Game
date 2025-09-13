class_name TargetSelect
extends HBoxContainer


var player_side_single: Array[TargetButton] = []
var enemy_side_single: Array[TargetButton] = []
var player_side_aoe: TargetButton
var enemy_side_aoe: TargetButton
var self_button: TargetButton

var actor_side: CombatRules.CombatSide

@onready var player_side_box = $"PlayerSide" as Control
@onready var enemy_side_box = $"EnemySide" as Control


func generate_buttons():
	for i in CombatRules.MAX_COMBATANTS_ON_A_SIDE:
		var new_button = TargetButton.new()
		player_side_single.push_back(new_button)
		new_button.hide()
		player_side_box.add_child(new_button)
	for i in CombatRules.MAX_COMBATANTS_ON_A_SIDE:
		var new_button = TargetButton.new()
		enemy_side_single.push_back(new_button)
		new_button.hide()
		enemy_side_box.add_child(new_button)
	var new_button = TargetButton.new()
	player_side_aoe = new_button
	new_button.hide()
	player_side_box.add_child(new_button)
	new_button = TargetButton.new()
	enemy_side_aoe = new_button
	new_button.hide()
	enemy_side_box.add_child(new_button)


func init_buttons(battlefield_info: BattlefieldInfo, actor: Combatant):
	_hide_all_buttons()
	
	for i in battlefield_info.player_side.size():
		var button = player_side_single[i]
		var ally = battlefield_info.player_side[i]
		button.stored_targets = [ally]
		if actor.combatant_side == CombatRules.CombatSide.PLAYER_SIDE:
			if actor == ally:
				button.target_type = CombatRules.ActionTargetType.SELF
				self_button = button
			else:
				button.target_type = CombatRules.ActionTargetType.SINGLE_SAME_SIDE
		else:
			button.target_type = CombatRules.ActionTargetType.SINGLE_OPP_SIDE
	player_side_aoe.stored_targets = battlefield_info.player_side.duplicate()
	if actor.combatant_side == CombatRules.CombatSide.PLAYER_SIDE:
		player_side_aoe.target_type = CombatRules.ActionTargetType.AOE_SAME_SIDE
	else:
		player_side_aoe.target_type = CombatRules.ActionTargetType.AOE_OPP_SIDE
	
	for i in battlefield_info.enemy_side.size():
		var button = enemy_side_single[i]
		var enemy = battlefield_info.enemy_side[i]
		button.stored_targets = [enemy]
		if actor.combatant_side == CombatRules.CombatSide.ENEMY_SIDE:
			if actor == enemy:
				button.target_type = CombatRules.ActionTargetType.SELF
				self_button = button
			else:
				button.target_type = CombatRules.ActionTargetType.SINGLE_SAME_SIDE
		else:
			button.target_type = CombatRules.ActionTargetType.SINGLE_OPP_SIDE
	enemy_side_aoe.stored_targets = battlefield_info.enemy_side.duplicate()
	if actor.combatant_side == CombatRules.CombatSide.ENEMY_SIDE:
		enemy_side_aoe.target_type = CombatRules.ActionTargetType.AOE_SAME_SIDE
	else:
		enemy_side_aoe.target_type = CombatRules.ActionTargetType.AOE_OPP_SIDE
		
	actor_side = actor.combatant_side


func show_target_type(target_type: CombatRules.ActionTargetType):
	_hide_all_buttons()
	match(target_type):
		CombatRules.ActionTargetType.AOE_BOTH_SIDE:
			player_side_aoe.show()
			enemy_side_aoe.show()
		CombatRules.ActionTargetType.AOE_SAME_SIDE:
			if actor_side == CombatRules.CombatSide.PLAYER_SIDE:
				player_side_aoe.show()
			else:
				enemy_side_aoe.show()
		CombatRules.ActionTargetType.AOE_OPP_SIDE:
			if actor_side == CombatRules.CombatSide.PLAYER_SIDE:
				enemy_side_aoe.show()
			else:
				player_side_aoe.show()
		CombatRules.ActionTargetType.SINGLE:
			for button in player_side_single:
				button.show()
			for button in enemy_side_single:
				button.show()
		CombatRules.ActionTargetType.SINGLE_SAME_SIDE:
			if actor_side == CombatRules.CombatSide.PLAYER_SIDE:
				for button in player_side_single:
					button.show()
			else:
				for button in enemy_side_single:
					button.show()
		CombatRules.ActionTargetType.SINGLE_OPP_SIDE:
			if actor_side == CombatRules.CombatSide.PLAYER_SIDE:
				for button in enemy_side_single:
					button.show()
			else:
				for button in player_side_single:
					button.show()
		CombatRules.ActionTargetType.SELF:
			self_button.show()


func _hide_all_buttons():
	for button in player_side_single:
			button.hide()
	for button in enemy_side_single:
		button.hide()
	player_side_aoe.hide()
	enemy_side_aoe.hide()
