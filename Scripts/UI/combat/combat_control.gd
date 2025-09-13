class_name CombatControl
extends Control



enum CombatMenuState {
	SELECT_ACTION_TYPE,
	SELECT_ACTION,
	SELECT_TARGET,
}

enum TypeSelected {
	ATTACK,
	SUPPORT,
	ITEMS,
	OTHER,
}

const LOAD_INITIAL_BUTTONS = 4


var attack_buttons: Array[ActionButton] = []
var support_buttons: Array[ActionButton] = []
var item_buttons: Array[ActionButton] = []
var other_buttons: Array[ActionButton] = []

var _actor: Combatant
var _chosen_action: ActionSelection
var _menu_state: CombatMenuState = CombatMenuState.SELECT_ACTION_TYPE
var _type_selected: TypeSelected = TypeSelected.ATTACK

@onready var action_type_select = $"ActionTypeSelect"
@onready var attack_select = $"AttackSelect"
@onready var support_select = $"SupportSelect"
@onready var item_select = $"ItemSelect"
@onready var other_select = $"OtherSelect"
@onready var back_button = $"BackButton"


func _ready():
	action_type_select.choose_attack.connect(_on_choose_attack)
	action_type_select.choose_support.connect(_on_choose_support)
	action_type_select.choose_items.connect(_on_choose_items)
	action_type_select.choose_other.connect(_on_choose_other)
	back_button.pressed.connect(_on_back_button)
	for i in LOAD_INITIAL_BUTTONS:
		_make_attack_button()
		_make_support_button()
		_make_item_button()
		_make_other_button()
	_hide_select_type()
	_change_to_state(CombatMenuState.SELECT_ACTION_TYPE)
	


func init_control(combatant: Combatant):
	for i in combatant.actions.possible_attacks.size():
		attach_action_to_button(attack_select, attack_buttons, i, 
			combatant.actions.possible_attacks[i])
	for i in combatant.actions.possible_supports.size():
		attach_action_to_button(support_select, support_buttons, i, 
			combatant.actions.possible_supports[i])
	for i in combatant.actions.possible_other.size():
		attach_action_to_button(other_select, other_buttons, i, 
			combatant.actions.possible_other[i])
	_actor = combatant
	show()


func attach_action_to_button(select: Control, buttons: Array[ActionButton], 
		num: int, action: ActionSelection):
	if num >= buttons.size():
		var button = ActionButton.new()
		buttons.push_back(button)
		select.add_child(button)
	buttons[num].stored_action = action


func _on_action_button_push(action: ActionSelection):
	_change_to_state(CombatMenuState.SELECT_TARGET)


func _on_choose_attack():
	_type_selected = TypeSelected.ATTACK
	_change_to_state(CombatMenuState.SELECT_ACTION)


func _on_choose_support():
	_type_selected = TypeSelected.SUPPORT
	_change_to_state(CombatMenuState.SELECT_ACTION)


func _on_choose_items():
	_type_selected = TypeSelected.ITEMS
	_change_to_state(CombatMenuState.SELECT_ACTION)


func _on_choose_other():
	_type_selected = TypeSelected.OTHER
	_change_to_state(CombatMenuState.SELECT_ACTION)


func _on_back_button():
	_change_to_state(_menu_state - 1)


func _hide_select_type():
	attack_select.hide()
	support_select.hide()
	item_select.hide()
	other_select.hide()


func _change_to_state(state: CombatMenuState):
	match(state):
		CombatMenuState.SELECT_ACTION_TYPE:
			back_button.hide()
			action_type_select.show()
			_hide_select_type()
		CombatMenuState.SELECT_ACTION:
			back_button.show()
			action_type_select.hide()
			match(_type_selected):
				TypeSelected.ATTACK:
					attack_select.show()
				TypeSelected.SUPPORT:
					support_select.show()
				TypeSelected.ITEMS:
					item_select.show()
				TypeSelected.OTHER:
					other_select.show()
		CombatMenuState.SELECT_TARGET:
			back_button.show()
			action_type_select.hide()
			_hide_select_type()
		_:
			push_error("Bad combat menu state.")
	_menu_state = state


func _make_attack_button() -> ActionButton:
	var attack_button = ActionButton.new()
	attack_buttons.push_back(attack_button)
	attack_button.action_button_pressed.connect(_on_action_button_push)
	attack_select.add_child(attack_button)
	return attack_button


func _make_support_button() -> ActionButton:
	var support_button = ActionButton.new()
	support_buttons.push_back(support_button)
	support_button.action_button_pressed.connect(_on_action_button_push)
	support_select.add_child(support_button)
	return support_button


func _make_item_button() -> ActionButton:
	var item_button = ActionButton.new()
	item_buttons.push_back(item_button)
	item_button.action_button_pressed.connect(_on_action_button_push)
	item_select.add_child(item_button)
	return item_button


func _make_other_button() -> ActionButton:
	var other_button = ActionButton.new()
	other_buttons.push_back(other_button)
	other_button.action_button_pressed.connect(_on_action_button_push)
	other_select.add_child(other_button)
	return other_button
