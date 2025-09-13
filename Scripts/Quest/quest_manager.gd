extends Node

signal quest_activated(quest: Quest)
signal quest_completed(quest: Quest)
signal quest_objective_completed(objective: QuestObjective)
signal interacted(interaction: ID.InteractionID)

var _quests : Dictionary[ID.QuestID, Quest]
var _active_quests : Array[Quest]
var _completed_quests : Array[Quest]
var _folder_path : String = "res://Data/Quests/"

func _ready():
	Inventory.inventory_changed.connect(_on_item_collected)
	interacted.connect(_on_interaction)
	LevelTransitionManager.level_transitioned.connect(_on_destination_reached)
	_load_quests_from_disk()
	
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

func activate_quest(quest_ID : ID.QuestID):
	if quest_ID == ID.QuestID.None:
		return
	var quest : Quest = _quests[quest_ID]
	if quest and not get_active_quest(quest_ID) and (not get_completed_quest(quest_ID) or quest.data.recurring):
		_active_quests.append(quest)
		quest.state = Quest.QuestState.ACTIVE
		quest_activated.emit(quest)
		print("Activated: ", quest.data.title)

func get_active_quest(quest_ID: ID.QuestID) -> Quest:
	for quest in _active_quests:
		if quest.data.quest_ID == quest_ID:
			return quest
	return null

func get_completed_quest(quest_ID: ID.QuestID) -> Quest:
	for quest in _completed_quests:
		if quest.data.quest_ID == quest_ID:
			return quest
	return null

## Complete quest by ID
func complete_quest(quest_ID : ID.QuestID):
	if quest_ID == ID.QuestID.None:
		return
	if _check_quest_completed(quest_ID):
		for i in _active_quests.size():
			if _active_quests[i].data.quest_ID == quest_ID:
				_active_quests[i].state = Quest.QuestState.COMPLETED
				_completed_quests.append(_active_quests[i])
				quest_completed.emit(_active_quests[i])
				print("Completed: ", _active_quests[i].data.title)
				_active_quests.remove_at(i)

func _check_quest_completed(quest_ID : ID.QuestID) -> bool:
	var quest = get_active_quest(quest_ID)
	if quest:
		for o in quest.objectives:
			if o.completed == false:
				return false
		return true
	else:
		return false

func _on_item_collected(item: Item):
	for q in _active_quests:
		for o in q.objectives:
			if o.data is ItemQuestObjective:
				if o.data.item == item.data.item_ID:
					o.progress = item.amount
					if o.progress >= o.data.amount:
						o.completed = true
						quest_objective_completed.emit(o)

func _on_combatant_defeated(combatant: ID.CombatantID):
	for q in _active_quests:
		for o in q.objectives:
			if o.data is DefeatQuestObjective:
				if o.data.combatant == combatant:
					o.progress += 1
					if o.progress >= o.data.amount:
						o.completed = true
						quest_objective_completed.emit(o)

func _on_destination_reached(destination: String):
	for q in _active_quests:
		for o in q.objectives:
			if o.data is DestinationQuestObjective:
				if o.data.destination == destination:
					o.completed = true
					quest_objective_completed.emit(o)
					
func _on_interaction(interaction: ID.InteractionID):
	for q in _active_quests:
		for o in q.objectives:
			if o.data is InteractionQuestObjective:
				if o.data.interaction == interaction:
					o.completed = true
					quest_objective_completed.emit(o)

## Returns a loaded quest from the quest folder
func _load_quests_from_disk():
	var dir_access = DirAccess.open(_folder_path)
	if dir_access:
		dir_access.list_dir_begin()
		var file_name = dir_access.get_next()
		while file_name != "":
			if not dir_access.current_is_dir(): 
				if file_name.ends_with(".tres"):
					var quest_path = _folder_path + "/" + file_name
					var quest_data : QuestData = ResourceLoader.load(quest_path) as QuestData
					if quest_data:
						var quest : Quest = Quest.new(quest_data)
						_quests[quest_data.quest_ID] = quest
						var objective_data : Array[QuestObjectiveData] = quest_data.objectives
						for data : QuestObjectiveData in objective_data:
							quest.objectives.append(QuestObjective.new(data))
			file_name = dir_access.get_next()
		dir_access.list_dir_end()
	else:
		print("Could not open directory: " + _folder_path)
