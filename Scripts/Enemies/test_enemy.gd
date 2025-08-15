extends Interactable

var is_chasing: bool = true
var spawn: Vector3
var target: Node3D
var wander_target: Vector3
var wander_timer: float = 0

const ACCELERATION = 5.0
const MAX_SPEED = 150.0
const WANDER_RADIUS = 150.0
const WANDER_TIMEOUT = 4.0

func _ready() -> void:
	pass
	#target = get_tree().get_first_node_in_group("Player")
	#if not target:
		#target = self
	#spawn = global_position
	#wander_target = spawn + Vector2(randf_range(-WANDER_RADIUS, WANDER_RADIUS), randf_range(-WANDER_RADIUS, WANDER_RADIUS))

func _physics_process(delta: float) -> void:
	pass
	#var direction: Vector2
	#if is_chasing:
		#direction = target.global_position - global_position
	#else:
		#if abs(global_position.distance_to(wander_target)) < 10.0 or wander_timer > WANDER_TIMEOUT:
			#print_debug(wander_target)
			#wander_target = spawn + Vector2(randf_range(-WANDER_RADIUS, WANDER_RADIUS), randf_range(-WANDER_RADIUS, WANDER_RADIUS))
			#wander_timer = 0
		#direction = wander_target - global_position
		#wander_timer += delta
	#velocity += direction.normalized() * ACCELERATION
	#if velocity.length() > MAX_SPEED:
		#velocity = direction.normalized() * MAX_SPEED
	#move_and_slide()
