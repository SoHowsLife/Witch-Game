class_name ActionTypeSelect
extends VBoxContainer


@onready var choose_attack: Signal = $"ChooseAttack".pressed
@onready var choose_support: Signal = $"ChooseSupport".pressed
@onready var choose_items: Signal = $"ChooseItems".pressed
@onready var choose_other: Signal = $"ChooseOther".pressed
