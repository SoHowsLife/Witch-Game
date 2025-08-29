extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_timeline(timeline: String = "error") -> void:
	if Dialogic.current_timeline != null:
		return
	Dialogic.start(timeline)
	
