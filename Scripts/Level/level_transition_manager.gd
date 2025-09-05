extends Control

@onready var animation = $AnimationPlayer

func level_transition(level: String, id: int):
	animation.play("fade_out")
	await animation.animation_finished
	if !ResourceLoader.exists(level):
		level = "res://Scenes/Level/OverworldTest.tscn"
	var change_report = get_tree().change_scene_to_file(level)
	await get_tree().create_timer(0.1).timeout
	var player : Player = get_tree().get_first_node_in_group("Player")
	var level_pos : LevelStartPos = get_tree().get_first_node_in_group("Level Positions")
	if id > level_pos.start_nodes.size():
		id = 0
	if level_pos.start_nodes[id] != null:
		player.position = level_pos.start_nodes[id].position
	animation.play("fade_in")
	player.can_move = true
