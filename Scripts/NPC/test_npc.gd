extends Interactable

@onready var sprite := $AnimatedSprite3D

func _ready() -> void:
	dialogic_name = "TestNPC"

func _process(delta: float) -> void:
	if Dialogic.VAR.TestNPC.TestOver:
		sprite.modulate.a = move_toward(sprite.modulate.a, 0, delta)
		if sprite.modulate.a <= 0.01:
			Dialogic.VAR.TestNPC.TestOver = false
			self.queue_free()

func interact() -> void:
	var timeline = "%s_msg" % dialogic_name
	print("Playing %s" % timeline)
	DialogueScreen.play_timeline(timeline)
