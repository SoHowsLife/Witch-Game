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


func _ready():
	_activate_quest("res://Data/Quests/ExampleQuest.tres")
	print(_active_quests[0].title)
	_complete_quest("res://Data/Quests/ExampleQuest.tres")
	print(_completed_quests[0].title)
	save_quest_data()

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
	
func is_quest_completed(quest_file_path : String) -> bool:
	for q in _active_quests:
		if q.path == quest_file_path:
			for o in q.objectives:
				if o.completed == false:
					return false
	return true
	
func _on_item_collected(name: StringName, amnt: int):
	_update_countable_objective(ObjectiveType.COLLECT, name, amnt)

func _on_enemy_slain(name: StringName, amnt: int):
	_update_countable_objective(ObjectiveType.SLAY, name, amnt)

func _update_countable_objective(obj_type: ObjectiveType, name: StringName, amnt: int):
	for q in _active_quests:
		for o in q.objectives:
			if o.type == obj_type:
				if o.target == name:
					o.progress = amnt
					if o.progress >= o.total:
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

## Activate quest by file path
func _activate_quest(quest_file_path : String):
	var quest : Quest = load(quest_file_path)
	if quest:
		quest.path = quest_file_path
		_active_quests.append(quest)
		quest_activated.emit(quest)
	else:
		print("Failed to activate quest.")

## Complete quest by file path
func _complete_quest(quest_file_path: String):
	for i in _active_quests.size():
		if _active_quests[i].path == quest_file_path:
			_completed_quests.append(_active_quests[i])
			quest_completed.emit(_active_quests[i])
			_active_quests.remove_at(i)
			return
	print("Failed to complete quest.")
