class_name Quest

enum QuestState {
	UNSTARTED,
	ACTIVE,
	COMPLETED,
}

var data : QuestData
var objectives : Array[QuestObjective]
var state : QuestState = QuestState.UNSTARTED

func _init(quest_data: QuestData):
	data = quest_data
