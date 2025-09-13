extends Interactable

@onready var sprite := $AnimatedSprite3D

func _ready() -> void:
	dialogic_name = "DebugNPC"

func interact() -> void:
	super()
	var timeline = "%s_msg" % dialogic_name
	print("Playing %s" % timeline)
	DialogueScreen.play_timeline(timeline)
