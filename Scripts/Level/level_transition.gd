extends Area3D
##Level that Area leads to
@export var target_level : String = "OverworldTest"
##The ID of the Marker3D that the player will spawn on (Needs Improvement)
@export var level_id : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D):
	print("Enter Transition")
	print(target_level)
	if body is Player:
		body.can_move = false
		LevelTransitionManager.level_transition(str("res://Scenes/Level/" + target_level + ".tscn"), level_id)
		LevelTransitionManager.level_transitioned.emit(target_level)

func on_body_exited(body: Node3D):
	print("Exit Transition")
