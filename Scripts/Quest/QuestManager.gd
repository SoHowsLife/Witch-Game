extends Node

signal quest_activated
signal quest_completed

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
	_activate_quest(ID.QuestID.ExampleQuest)
	print("Active: " + _active_quests[0].title)
	_on_item_collected(ID.ItemID.ExampleItem, 1)
	print(_active_quests[0].objectives[0].completed)

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
	
func is_quest_completed(quest_id : ID.QuestID) -> bool:
	for q in _active_quests:
		if q.ID == quest_id:
			for o in q.objectives:
				if o.completed == false:
					return false
	return true
	
func _on_item_collected(item_id: ID.ItemID, amnt: int):
	_update_item_objective(item_id, amnt)

func _on_enemy_slain(name: StringName, amnt: int):
	pass

func _update_item_objective(item_id: ID.ItemID, amnt: int):
	for q in _active_quests:
		for o in q.objectives:
			if o is ItemQuestObjective:
				o = o as ItemQuestObjective
				if o.item == item_id:
					o.progress = amnt
					if o.progress >= o.amount:
						o.completed = true

func _on_destination_reached(destination: StringName):
	_update_uncountable_objective(ObjectiveType.SLAY, name)
					
func _on_interaction(interaction: StringName):
	_update_uncountable_objective(ObjectiveType.SLAY, name)
					
func _update_uncountable_objective(obj_type: ObjectiveType, name: StringName):
	for q in _active_quests:
		for o in q.objectives:
			if o.type == obj_type:
				if o.target == name:
					o.completed = true

## Activate quest by ID
func _activate_quest(quest_id : ID.QuestID):
	var quest : Quest = _load_quest(quest_id)
	if quest:
		_active_quests.append(quest)
		quest_activated.emit(quest)
	else:
		print("Failed to activate quest.")

## Complete quest by ID
func _complete_quest(quest_id : ID.QuestID):
	for i in _active_quests.size():
		if _active_quests[i].ID == quest_id:
			_completed_quests.append(_active_quests[i])
			quest_completed.emit(_active_quests[i])
			_active_quests.remove_at(i)
			return
	print("Failed to complete quest.")

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
					if quest and quest.ID == quest_id:
						dir_access.list_dir_end()
						return quest
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
		return null
	else:
		print("Could not open directory: " + _folder_path)
		return null
