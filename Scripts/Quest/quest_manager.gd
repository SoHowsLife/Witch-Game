extends Node

signal quest_activated
signal quest_completed
signal interacted

enum ObjectiveType {
	COLLECT,
	SLAY,
	DESTINATION,
	INTERACT,
}

var _active_quests : Array[Quest]
var _completed_quests : Array[Quest]
var _folder_path : String = "res://Data/Quests/"

func _ready():
	Inventory.inventory_changed.connect(_on_item_collected)
	interacted.connect(_on_interaction)
	
func _process(delta):
	pass

## Returns array of all active quests
func get_active_quests() -> Array[Quest]:
	return _active_quests
	
## Returns array of all completed quests
func get_completed_quests() -> Array[Quest]:
	return _completed_quests

func save_quest_data() -> Dictionary:
	var quest_dict : Dictionary = {
		"active" : _active_quests,
		"completed" : _completed_quests,
	}
	return quest_dict

func load_quest_data(quest_dict : Dictionary):
	_active_quests = quest_dict.get("active")
	_completed_quests = quest_dict.get("completed")

func activate_quest(quest_id : ID.QuestID):
	var quest : Quest = _load_quest(quest_id)
	if quest and not get_active_quest(quest_id) and (not get_completed_quest(quest_id) or quest.recurring):
		_active_quests.append(quest)
		quest_activated.emit(quest)

func get_active_quest(quest_id: ID.QuestID) -> Quest:
	for quest in _active_quests:
		if quest.quest_id == quest_id:
			return quest
	return null

func get_completed_quest(quest_id: ID.QuestID) -> Quest:
	for quest in _completed_quests:
		if quest.quest_id == quest_id:
			return quest
	return null

## Complete quest by ID
func complete_quest(quest_id : ID.QuestID):
	if _check_quest_completed(quest_id):
		for i in _active_quests.size():
			if _active_quests[i].quest_id == quest_id:
				_completed_quests.append(_active_quests[i])
				quest_completed.emit(_active_quests[i])
				_active_quests.remove_at(i)

func _check_quest_completed(quest_id : ID.QuestID) -> bool:
	var quest = get_active_quest(quest_id)
	if quest:
		for o in quest.objectives:
			if o.completed == false:
				return false
		return true
	else:
		return false

func _on_item_collected(item_id: ID.ItemID, amnt: int):
	for q in _active_quests:
		for o in q.objectives:
			if o is ItemQuestObjective:
				o = o as ItemQuestObjective
				if o.item == item_id:
					o.progress = amnt
					if o.progress >= o.amount:
						o.completed = true

func _on_enemy_slain(name: StringName, amnt: int):
	pass

func _on_destination_reached(destination: StringName):
	pass
					
func _on_interaction(interaction: ID.InteractionID):
	for q in _active_quests:
		for o in q.objectives:
			if o is InteractionQuestObjective:
				if o.interaction == interaction:
					o.completed = true

## Returns a loaded quest from the quest folder
func _load_quest(quest_id : ID.QuestID) -> Quest:
	var dir_access = DirAccess.open(_folder_path)
	
	if dir_access:
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()
		while file_name != "":
			if not dir_access.current_is_dir(): 
				if file_name.ends_with(".tres"):
					var quest_path = _folder_path + "/" + file_name
					var quest = ResourceLoader.load(quest_path) as Quest
					if quest and quest.quest_id == quest_id:
						dir_access.list_dir_end()
						return quest
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
		return null
	else:
		print("Could not open directory: " + _folder_path)
		return null
