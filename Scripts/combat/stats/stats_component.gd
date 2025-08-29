class_name StatsComponent
extends Node

signal stats_changed
signal hp_at_zero

var _level: int = 0
var _base_HP: float = 100
var _base_HP_scaling_factor: float = 2.5
var _base_ATK: float = 10
var _base_ATK_scaling_factor: float = 2
var _base_DEF: float = 10
var _base_DEF_scaling_factor: float = 2

var additional_crit_chance: float = 0
var additional_crit_multiplier: float = 0

var _active_resist_spreads: Array[ElementalSpreadData]
var _active_ele_pen_spreads: Array[ElementalSpreadData]
var _active_atk_multipliers: Array[MultiplierInstance]
var _active_def_multipliers: Array[MultiplierInstance]
var _active_outdmg_multipliers: Array[MultiplierInstance]
var _active_indmg_reduction: Array[MultiplierInstance]

var MAX_HP: float = 0:
	set(x):
		MAX_HP = x
		stats_changed.emit()
var effective_ATK: float = 0:
	set(x):
		effective_ATK = x
		stats_changed.emit()
var effective_DEF: float = 0:
	set(x):
		effective_DEF = x
		stats_changed.emit()
var effective_DEF_for_crit: float = 0:
	set(x):
		effective_DEF_for_crit = x
		stats_changed.emit()
var effective_outdmg_multiplier: float = 0:
	set(x):
		effective_outdmg_multiplier = x
		stats_changed.emit()
var effective_indmg_reduction: float = 1:
	set(x):
		effective_indmg_reduction = x
		stats_changed.emit()

var current_HP: float = 1:
	set(x):
		current_HP = clampf(x, 0, MAX_HP)
		if is_zero_approx(current_HP):
			hp_at_zero.emit()


func _init(stat_spread: StatSpreadData):
	_base_HP = stat_spread.base_HP
	_base_ATK = stat_spread.base_ATK
	_base_DEF = stat_spread.base_DEF
	_base_HP_scaling_factor = stat_spread.base_HP_scaling_factor
	_base_ATK_scaling_factor = stat_spread.base_ATK_scaling_factor
	_base_DEF_scaling_factor = stat_spread.base_DEF_scaling_factor
	apply_elemental_resist_spread(stat_spread.base_resistances)


func _ready():
	force_update_stats()
	current_HP = MAX_HP


func get_resist_multiplier(element: CombatRules.Elements) -> float:
	var resist_multiplier: float = 0
	for spread in _active_resist_spreads:
		resist_multiplier += spread.get_element_multiplier(element)
	return resist_multiplier


func get_ele_pen(element: CombatRules.Elements) -> float:
	var pen: float = 0
	for spread in _active_resist_spreads:
		pen += spread.get_element_multiplier(element)
	return pen


func calc_effective_MAX_HP() -> float:
	return CombatRules.calc_level_scaled_stat(_base_HP, _level, _base_HP_scaling_factor)


func calc_effective_ATK() -> float:
	var scaled_atk = CombatRules.calc_level_scaled_stat(_base_ATK, _level, _base_ATK_scaling_factor)
	var atk_multiplier: float = 0
	for multiplier in _active_atk_multipliers:
		atk_multiplier += multiplier.multiplier_value
	return scaled_atk * atk_multiplier


func calc_effective_DEF() -> float:
	var scaled_def = CombatRules.calc_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor)
	var def_multiplier: float = 0
	for multiplier in _active_def_multipliers:
		def_multiplier += multiplier.multiplier_value
	return scaled_def * def_multiplier


func calc_outdmg_multiplier() -> float:
	var total_mult: float = 0
	for multiplier in _active_outdmg_multipliers:
		total_mult += multiplier.multiplier_value
	return total_mult


func calc_indmg_reduction() -> float:
	var total_mult: float = 1
	for multiplier in _active_indmg_reduction:
		total_mult *= multiplier.multiplier_value
	return total_mult


func force_update_stats():
	MAX_HP = calc_effective_MAX_HP()
	effective_ATK = calc_effective_ATK()
	effective_DEF = calc_effective_DEF()
	effective_DEF_for_crit = CombatRules.calc_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor)
	effective_outdmg_multiplier = calc_outdmg_multiplier()
	effective_indmg_reduction = calc_indmg_reduction()


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


func deapply_elemental_resist_spread(spread: ElementalSpreadData):
	_active_resist_spreads.erase(spread)
