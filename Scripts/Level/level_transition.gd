extends Area3D
##Level that Area leads to
@export var target_level : PackedScene = preload("res://Scenes/OverworldTest.tscn")
##The ID of the Marker3D that the player will spawn on (Needs Improvement)
@export var level_id : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func on_body_entered(body: Node3D):
	print("Enter Transition")
	if body is Player:
		body.can_move = false
	LevelTransitionManager.level_transition(target_level, level_id)

func on_body_exited(body: Node3D):
	print("Exit Transition")
