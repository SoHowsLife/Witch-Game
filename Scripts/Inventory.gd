extends Node

enum EquipType {
	NONE,
	ARMOR,
	WEAPON,
}

enum Category {
	TRADE, ## Item is for selling to NPCs
	WEAPON, ## Item can be equipped as a weapon
	ARMOR, ## Item can be equipped as armor
	POTION,  ## Item can be consumed in battle for hp/buffs
	RUNE, ## Item is a rune
	QUEST, ## Item is for a quest
}

var _items : Dictionary[ID.ItemID, ItemData]
var _folder_path = "res://Data/Items/"

## Emitted when the inventory changes. [br]
## Returns item ID of altered item and the new item amount after the change.
signal inventory_changed

func _ready():
	_load_items_from_disk()

## Returns an item regardless of stack size
func get_item(item_id : ID.ItemID) -> ItemData:
	return _items.get(item_id)

## Returns an item if the player owns at least one. Returns null otherwise.
func has_item(item_id : ID.ItemID) -> ItemData:
	var item : ItemData = _items.get(item_id)
	if item.amount > 0:
		return item 
	else:
		return null

## Returns array of items the player owns
func get_all_player_items() -> Array[ItemData]:
	var player_items : Array[ItemData]
	for id in _items:
		var item : ItemData = _items.get(id)
		if item.amount > 0:
			player_items.append(item)
	return player_items
	
## Returns array of items in a certain category that the player owns
func get_all_player_items_in_category(category : Category) -> Array[ItemData]:
	var player_items : Array[ItemData]
	for id in _items:
		var item : ItemData = _items.get(id)
		if item.amount > 0 and item.category == category:
			player_items.append(item)
	return player_items
	
func add_item(item_id : ID.ItemID, amount_added : int):
	amount_added = abs(amount_added)
	_alter_item_amount(item_id, amount_added)
	
func remove_item(item_id : ID.ItemID, amount_removed : int):
	amount_removed = abs(amount_removed)
	_alter_item_amount(item_id, -amount_removed)

func _alter_item_amount(item_id : ID.ItemID, amount_altered : int):
	var item : ItemData = _items.get(item_id)
	item.amount = clamp(item.amount + amount_altered, 0, 999)
	inventory_changed.emit(item_id, item.amount)

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
					var item = ResourceLoader.load(item_path) as ItemData
					if item:
						_items[item.item_id] = item
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	else:
		print("Could not open directory: " + _folder_path)
