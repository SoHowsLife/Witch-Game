class_name StatsComponent
extends Node

signal stats_changed
signal speed_changed(new_speed: float, old_speed: float)
signal hp_at_zero

var _level: int = 0
var _base_HP: float = 100
var _base_HP_scaling_factor: float = 2.5
var _base_ATK: float = 10
var _base_ATK_scaling_factor: float = 2
var _base_DEF: float = 10
var _base_DEF_scaling_factor: float = 1.5
var _base_SPD: float = 10
var _base_SPD_scaling_factor: float = 1.2

var _active_resist_spreads: Array[ElementalSpreadData]
var _active_ele_pen_spreads: Array[ElementalSpreadData]
var _active_atk_multipliers: Array[MultiplierInstance]
var _active_def_multipliers: Array[MultiplierInstance]
var _active_outdmg_multipliers: Array[MultiplierInstance]
var _active_indmg_reduction: Array[MultiplierInstance]
var _active_crit_chance_modifiers: Array[MultiplierInstance]
var _active_crit_multiplier_modifiers: Array[MultiplierInstance]
var _active_speed_modifiers: Array[MultiplierInstance]


var MAX_HP: float = 0:
	get:
		return MAX_HP
	set(x):
		MAX_HP = x
		stats_changed.emit()
var effective_ATK: float = 0:
	get:
		return effective_ATK
	set(x):
		effective_ATK = x
		stats_changed.emit()
var effective_DEF: float = 1:
	get:
		return effective_DEF
	set(x):
		effective_DEF = clampf(x, 0.001, INF)
		stats_changed.emit()
var effective_DEF_for_crit: float = 1:
	get:
		return effective_DEF_for_crit
	set(x):
		effective_DEF_for_crit = clampf(x, 0.001, INF)
		stats_changed.emit()
var effective_outdmg_multiplier: float = 0:
	get:
		return effective_outdmg_multiplier
	set(x):
		effective_outdmg_multiplier = x
		stats_changed.emit()
var effective_indmg_reduction: float = 1:
	get:
		return effective_indmg_reduction
	set(x):
		effective_indmg_reduction = x
		stats_changed.emit()
var additional_crit_chance: float = 0:
	get:
		return additional_crit_chance
	set(x):
		additional_crit_chance = x
		stats_changed.emit()
var additional_crit_multiplier: float = 0:
	get:
		return additional_crit_multiplier
	set(x):
		additional_crit_multiplier = x
		stats_changed.emit()
var effective_SPD: float = 10:
	get:
		return effective_SPD
	set(new_speed):
		speed_changed.emit(new_speed, effective_SPD)
		effective_SPD = new_speed


var current_HP: float = 1:
	set(x):
		current_HP = clampf(x, 0, MAX_HP)
		if is_zero_approx(current_HP):
			hp_at_zero.emit()


func _ready():
	force_update_stats()
	current_HP = MAX_HP


func update_level(value: int):
	_level = clampi(value, 1, INF)


func init_stats(stat_spread: StatSpreadData, level: int = 1):
	update_level(level)
	_base_HP = stat_spread.base_HP
	_base_ATK = stat_spread.base_ATK
	_base_DEF = stat_spread.base_DEF
	_base_SPD = stat_spread.base_SPD
	_base_HP_scaling_factor = stat_spread.base_HP_scaling_factor
	_base_ATK_scaling_factor = stat_spread.base_ATK_scaling_factor
	_base_DEF_scaling_factor = stat_spread.base_DEF_scaling_factor
	apply_elemental_resist_spread(stat_spread.base_resistances)
	current_HP = MAX_HP
	force_update_stats()


func get_resist_multiplier(element: CombatRules.Elements) -> float:
	var resist_multiplier: float = 0
	for spread in _active_resist_spreads:
		resist_multiplier += spread.get_element_multiplier(element)
	return resist_multiplier


func get_ele_pen(element: CombatRules.Elements) -> float:
	var pen: float = 0
	for spread in _active_ele_pen_spreads:
		pen += spread.get_element_multiplier(element)
	return pen


func calc_effective_MAX_HP() -> float:
	return CombatRules.calc_level_scaled_stat(_base_HP, _level, _base_HP_scaling_factor)


func calc_effective_ATK() -> float:
	var scaled_atk = CombatRules.calc_level_scaled_stat(_base_ATK, _level, _base_ATK_scaling_factor)
	var atk_multiplier: float = 1
	for multiplier in _active_atk_multipliers:
		atk_multiplier += multiplier.multiplier_value
	return scaled_atk * atk_multiplier


func calc_effective_DEF() -> float:
	var scaled_def = CombatRules.calc_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor)
	var def_multiplier: float = 1
	for multiplier in _active_def_multipliers:
		def_multiplier += multiplier.multiplier_value
	return scaled_def * def_multiplier


func calc_outdmg_multiplier() -> float:
	var total_mult: float = 1
	for multiplier in _active_outdmg_multipliers:
		total_mult += multiplier.multiplier_value
	return total_mult


func calc_indmg_reduction() -> float:
	var total_mult: float = 1
	for multiplier in _active_indmg_reduction:
		total_mult *= multiplier.multiplier_value
	return total_mult

func calc_crit_chance() -> float:
	var total_chance: float = 0
	for multiplier in _active_crit_chance_modifiers:
		total_chance += multiplier.multiplier_value
	return total_chance


func calc_crit_multi() -> float:
	var total_mult: float = 0
	for multiplier in _active_crit_multiplier_modifiers:
		total_mult += multiplier.multiplier_value
	return total_mult


func calc_effective_SPD() -> float:
	var scaled_spd = CombatRules.calc_level_scaled_stat(_base_SPD, _level, _base_SPD_scaling_factor)
	var total_mult: float = 1
	for multiplier in _active_speed_modifiers:
		total_mult += multiplier.multiplier_value
	return scaled_spd * total_mult


func force_update_stats():
	MAX_HP = calc_effective_MAX_HP()
	effective_ATK = calc_effective_ATK()
	effective_DEF = calc_effective_DEF()
	effective_DEF_for_crit = CombatRules.calc_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor)
	effective_outdmg_multiplier = calc_outdmg_multiplier()
	effective_indmg_reduction = calc_indmg_reduction()
	effective_SPD = calc_effective_SPD()


func apply_ATK_multiplier(instance: MultiplierInstance):
	_active_atk_multipliers.push_back(instance)
	effective_ATK = calc_effective_ATK()


func apply_DEF_multiplier(instance: MultiplierInstance):
	_active_def_multipliers.push_back(instance)
	effective_DEF = calc_effective_DEF()


func apply_outdmg_multiplier(instance: MultiplierInstance):
	_active_outdmg_multipliers.push_back(instance)
	effective_outdmg_multiplier = calc_outdmg_multiplier()


func apply_indmg_reduction(instance: MultiplierInstance):
	_active_indmg_reduction.push_back(instance)
	effective_indmg_reduction = calc_indmg_reduction()


func apply_crit_chance_modifier(instance: MultiplierInstance):
	_active_crit_chance_modifiers.push_back(instance)
	additional_crit_chance = calc_crit_chance()


func apply_crit_multi_modifier(instance: MultiplierInstance):
	_active_crit_multiplier_modifiers.push_back(instance)
	additional_crit_multiplier = calc_crit_multi()


func apply_speed_multiplier(instance: MultiplierInstance):
	_active_speed_modifiers.push_back(instance)
	effective_SPD = calc_effective_SPD()


func apply_elemental_resist_spread(spread: ElementalSpreadData):
	_active_resist_spreads.push_back(spread)


func deapply_ATK_multiplier(instance: MultiplierInstance):
	_active_atk_multipliers.erase(instance)
	effective_ATK = calc_effective_ATK()


func deapply_DEF_multiplier(instance: MultiplierInstance):
	_active_def_multipliers.erase(instance)
	effective_DEF = calc_effective_DEF()


func deapply_outdmg_multiplier(instance: MultiplierInstance):
	_active_outdmg_multipliers.erase(instance)
	effective_outdmg_multiplier = calc_outdmg_multiplier()


func deapply_indmg_reduction(instance: MultiplierInstance):
	_active_indmg_reduction.erase(instance)
	effective_indmg_reduction = calc_indmg_reduction()


func deapply_crit_chance_modifier(instance: MultiplierInstance):
	_active_crit_chance_modifiers.erase(instance)
	additional_crit_chance = calc_crit_chance()


func deapply_crit_multi_modifier(instance: MultiplierInstance):
	_active_crit_multiplier_modifiers.erase(instance)
	additional_crit_multiplier = calc_crit_multi()


func deapply_speed_multiplier(instance: MultiplierInstance):
	_active_speed_modifiers.erase(instance)
	effective_SPD = calc_effective_SPD()


func deapply_elemental_resist_spread(spread: ElementalSpreadData):
	_active_resist_spreads.erase(spread)
