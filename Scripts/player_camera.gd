extends Camera3D

var target : Node3D
@export_range(0, 1, 0.1) var lerp_speed = 0.1

func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.lerp(target.global_position, lerp_speed)
	pass
