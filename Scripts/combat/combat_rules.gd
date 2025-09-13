extends Node

const DEFAULT_LEVEL_SCALE_FACTOR: float = 2
const DEFAULT_MULT_EVERY_X: float = 10

enum Elements {
	NONELEMENTAL = -1,
	FIRE,
	WATER,
	AIR,
	EARTH,
	ICE,
	LIGHTNING,
	POISON,
}

enum ActionType {
	ATTACK,
	SUPPORT,
	OTHER,
}

enum ActionTargetType {
	SINGLE,
	SINGLE_SAME_SIDE,
	SINGLE_OPP_SIDE,
	SELF,
	AOE_SAME_SIDE,
	AOE_OPP_SIDE,
	AOE_BOTH_SIDE,
}

enum CombatSide {
	PLAYER_SIDE,
	ENEMY_SIDE,
}

func do_attack(attacker: Combatant, defender: Combatant, attack: AttackData) -> DamageInstance:
	var is_crit = roll_for_crit(attacker.stats, attack)
	var instance = DamageInstance.new()
	instance.source = attacker
	instance.defender = defender
	instance.unmitigated_damage_dealt = calc_damage(attacker.stats, defender.stats, attack, is_crit)
	instance.element = attack.element
	instance.is_crit = is_crit
	defender.receive_damage_instance(instance)
	return instance


func do_unmitigated_damage(value: float, defender: Combatant) -> DamageInstance:
	var instance = DamageInstance.new()
	instance.defender = defender
	instance.unmitigated_damage_dealt = value
	instance.is_crit = false
	return instance



func calc_level_scaled_stat(base_stat: float, level: float, level_factor: float = DEFAULT_LEVEL_SCALE_FACTOR,
		mult_every_x: float = DEFAULT_MULT_EVERY_X) -> float:
	var level_multiplier = pow(level_factor, level / mult_every_x)
	return base_stat * level_multiplier


func roll_for_crit(attacker: StatsComponent, attack: AttackData) -> bool:
	var effective_crit_chance = attacker.additional_crit_chance + attack.critical_hit_chance
	if randf() < effective_crit_chance:
		return true
	else:
		return false


func calc_damage(attacker: StatsComponent, defender: StatsComponent, 
		attack: AttackData, is_crit: bool) -> float:
	var outgoing_damage: float = _calculate_outgoing_damage(attack, attacker, is_crit)
	var incoming_damage_modifier: float = _calculate_incoming_damage_modifier(defender, is_crit)
	var elemental_modifier: float = _calculate_elemental_modifier(attack.element, defender, 
		attacker.get_ele_pen(attack.element))
	return outgoing_damage * incoming_damage_modifier * elemental_modifier


func _calculate_outgoing_damage(attack: AttackData, attacker: StatsComponent, is_crit: bool) -> float:
	if is_crit:
		return (attacker.effective_ATK * attack.power * attacker.effective_outdmg_multiplier * 
			(attack.crit_multiplier + attacker.additional_crit_multiplier))
	else:
		return attacker.effective_ATK * attack.power * attacker.effective_outdmg_multiplier


func _calculate_incoming_damage_modifier(defender: StatsComponent, is_crit: bool) -> float:
	if is_crit:
		return (1 / defender.effective_DEF_for_crit) * defender.effective_indmg_reduction
	else:
		return (1 / defender.effective_DEF) * defender.effective_indmg_reduction
		


func _calculate_elemental_modifier(element: Elements, defender: StatsComponent,
		penetration: float) -> float:
	return defender.get_resist_multiplier(element) + penetration + 1.0
