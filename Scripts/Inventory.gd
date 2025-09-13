extends Node

## Emitted when the inventory changes. [br]
## Returns item ID of the altered item
signal inventory_changed(item : Item)

## Emitted when an item is equipped. [br]
## Returns item ID of the equipped item.
signal item_equipped(item : Item)

enum EquipType {
	WEAPON,
	HEAD,
	BODY,
	ACCESSORY,
}

enum Category {
	EQUIPMENT, ## Item can be equipped by the player
	CONSUMABLE,  ## Item can be consumed in battle for hp/buffs
	RUNE, ## Item is a rune
	KEY, ## Item is for a quest
}

var currency: int = 0:
	set(new_value):
		currency = new_value
	get():
		return currency


var _items : Dictionary[ID.ItemID, Item]
var _equipped_items : Array[Item]
var _folder_path = "res://Data/Items/"

func _ready():
	CombatManager.tracking_action_used.connect(_on_combat_action)
	_load_items_from_disk()

## Returns an item instance using its id
func get_item(item_ID : ID.ItemID) -> Item:
	return _items.get(item_ID)

## Returns an item if the player owns at least one. Returns null otherwise.
func has_item(item_ID : ID.ItemID) -> Item:
	var item = get_item(item_ID)
	if item.amount > 0:
		return item 
	else:
		return null

## Attempts to equip an item in its proper slot. Will replace any currently equipped item. Returns true if the item was successfully equipped.
func equip_item(item : Item) -> bool:
	if item.data.equippable:
		_equipped_items[item.data.equip_type] = item
		item_equipped.emit(item)
		return true
	return false

## Will unequip the specified item
func unequip_item(item : Item):
	if item.data.equippable:
		_equipped_items[item.data.equip_type] = null

## Returns an array of currently equipped items
func get_equipped_items() -> Array[Item]:
	return _equipped_items

## Returns the item instance of the item equipped in the specified slot
func get_equipped_item(slot : EquipType) -> Item:
	return _equipped_items[EquipType]

## Returns array of items the player owns
func get_all_player_items() -> Array[Item]:
	var player_items : Array[Item]
	for id in _items:
		var item : Item = _items.get(id)
		if item.amount > 0:
			player_items.append(item)
	return player_items
	
## Returns array of items in a certain category that the player owns
func get_all_player_items_in_category(category : Category) -> Array[Item]:
	var player_items : Array[Item]
	for id in _items:
		var item : Item = _items.get(id)
		if item.amount > 0 and item.data.category == category:
			player_items.append(item)
	return player_items

func _on_combat_action(user_ID: ID.CombatantID, instance: ActionInstance):
	for item in _equipped_items:
		item.behavior.on_action(user_ID, instance)

## Loads all items from disk into a dictionary
func _load_items_from_disk():
	var dir_access = DirAccess.open(_folder_path)
	if dir_access:
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()
		while file_name != "":
			if not dir_access.current_is_dir(): 
				if file_name.ends_with(".tres"):
					var item_path = _folder_path + "/" + file_name
					var item_data = ResourceLoader.load(item_path) as ItemData
					if item_data:
						var item : Item = Item.new(item_data)
						_items[item_data.item_ID] = item
						var behavior = item_data.equip_data.item_behavior_script
						if behavior: 
							item.behavior = item_data.equip_data.item_behavior_script.new()
						
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	else:
		print("Could not open directory: " + _folder_path)
