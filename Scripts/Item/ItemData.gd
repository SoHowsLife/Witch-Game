extends Resource

class_name ItemData

@export_category("ID")
## Internal ID for the item
@export var item_id : ID.ItemID = ID.ItemID.None

@export_category("Basic Info")
## Display name of the item
@export var name : String = "Basic Item"
## Item's description/flavor text.
@export var description : String = "A basic item."
## Which category should the item fall under.
@export var category : Inventory.Category
## Texture for displaying the item.
@export var texture : Texture2D

@export_category("Interaction Info")
## Item can be used in the world.
@export var usable_in_world : bool = false
## Item can be used in battle.
@export var usable_in_battle : bool = false
## Item is consumed when used.
@export var consumable : bool = false

@export_category("Shop Info")
## Amount item can be bought from shops for.
@export var buy_price : int = 0
## Amount item can be sold to shops for. Price of 0 cannot be sold.
@export var sell_price : int = 0

@export_category("Equipment Data")
## If and how the item can be equipped
@export var equip_type : Inventory.EquipType = Inventory.EquipType.NONE
## Apply changes to the player when equipped
@export var equip_data : EquipData

var amount = 0
