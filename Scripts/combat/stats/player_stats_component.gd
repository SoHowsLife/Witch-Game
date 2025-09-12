class_name PlayerStatsComponent
extends StatsComponent

var equipment_HP: float = 0
var equipment_ATK: float = 0
var equipment_DEF: float = 0


func clear_equip_stats():
	equipment_HP = 0
	equipment_ATK = 0
	equipment_DEF = 0


func add_equip_stats(equipment: EquipData):
	equipment_ATK += equipment.attack
	equipment_DEF += equipment.defense
	equipment_HP += equipment.max_health


func force_update_stats():
	MAX_HP = calc_effective_MAX_HP()
	effective_ATK = calc_effective_ATK()
	effective_DEF = calc_effective_DEF()
	effective_DEF_for_crit = CombatRules.calc_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor) + equipment_DEF
	effective_outdmg_multiplier = calc_outdmg_multiplier()
	effective_indmg_reduction = calc_indmg_reduction()


func get_effective_MAX_HP() -> float:
	return CombatRules.get_level_scaled_stat(_base_HP, _level, _base_HP_scaling_factor) + equipment_HP


func get_effective_ATK() -> float:
	var scaled_atk = CombatRules.get_level_scaled_stat(_base_ATK, _level, _base_ATK_scaling_factor) + equipment_ATK
	var atk_multiplier: float = 0
	for multiplier in _active_atk_multipliers:
		atk_multiplier += multiplier.multiplier_value
	return scaled_atk * atk_multiplier


func get_effective_DEF() -> float:
	var scaled_def = CombatRules.get_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor) + equipment_DEF
	var def_multiplier: float = 0
	for multiplier in _active_def_multipliers:
		def_multiplier += multiplier.multiplier_value
	return scaled_def * def_multiplier
