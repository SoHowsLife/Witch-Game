class_name StatsComponent
extends Node

var _level: int = 0
var _base_HP: float = 100
var _base_ATK: float = 10
var _base_DEF: float = 10

var _active_resist_spreads: Array[ResistanceSpreadData]
var _active_atk_multipliers: Array[MultiplierInstance]
var _active_def_multipliers: Array[MultiplierInstance]
var _active_outdmg_multipliers: Array[MultiplierInstance]
var _active_indmg_reduction: Array[MultiplierInstance]


var max_hp
var hp
