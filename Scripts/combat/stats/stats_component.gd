class_name StatsComponent
extends Node

signal stats_changed

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

var current_HP: float = 0:
	set(x):
		current_HP = clampi(x, 0, MAX_HP)


func _init(stat_spread: Resource):
	pass


func _ready():
	force_update_stats()


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


func get_effective_MAX_HP() -> float:
	return CombatRules.get_level_scaled_stat(_base_HP, _level, _base_HP_scaling_factor)


func get_effective_ATK() -> float:
	var scaled_atk = CombatRules.get_level_scaled_stat(_base_ATK, _level, _base_ATK_scaling_factor)
	var atk_multiplier: float = 0
	for multiplier in _active_atk_multipliers:
		atk_multiplier += multiplier.multiplier_value
	return scaled_atk * atk_multiplier


func get_effective_DEF() -> float:
	var scaled_def = CombatRules.get_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor)
	var def_multiplier: float = 0
	for multiplier in _active_def_multipliers:
		def_multiplier += multiplier.multiplier_value
	return scaled_def * def_multiplier


func get_outdmg_multiplier() -> float:
	var total_mult: float = 0
	for multiplier in _active_outdmg_multipliers:
		total_mult += multiplier.multiplier_value
	return total_mult


func get_indmg_reduction() -> float:
	var total_mult: float = 1
	for multiplier in _active_indmg_reduction:
		total_mult *= multiplier.multiplier_value
	return total_mult


func force_update_stats():
	MAX_HP = get_effective_MAX_HP()
	effective_ATK = get_effective_ATK()
	effective_DEF = get_effective_DEF()
	effective_DEF_for_crit = CombatRules.get_level_scaled_stat(_base_DEF, _level, _base_DEF_scaling_factor)
	effective_outdmg_multiplier = get_outdmg_multiplier()
	effective_indmg_reduction = get_indmg_reduction()


func apply_ATK_multiplier(instance: MultiplierInstance):
	_active_atk_multipliers.push_back(instance)
	effective_ATK = get_effective_ATK()


func apply_DEF_multiplier(instance: MultiplierInstance):
	_active_def_multipliers.push_back(instance)
	effective_DEF = get_effective_DEF()


func apply_outdmg_multiplier(instance: MultiplierInstance):
	_active_outdmg_multipliers.push_back(instance)
	effective_outdmg_multiplier = get_outdmg_multiplier()


func apply_indmg_reduction(instance: MultiplierInstance):
	_active_indmg_reduction.push_back(instance)
	effective_indmg_reduction = get_indmg_reduction()
