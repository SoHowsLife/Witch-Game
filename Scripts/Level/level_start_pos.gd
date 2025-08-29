@tool
class_name LevelStartPos
extends Node3D

@export var start_nodes : Array[Marker3D]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if start_nodes.size() <= 20:
			for marker in start_nodes:
				marker.name = str(marker.get_index())
	pass
