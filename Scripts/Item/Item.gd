class_name Item

var data : ItemData
var behavior : ItemBehavior
var amount: int = 0:
	set(new_value):
		amount = clamp(new_value, 0, 999)
		Inventory.inventory_changed.emit(self)
	get():
		return amount

func _init(item_data: ItemData):
	data = item_data
