extends CharacterBody3D

var camera : Camera3D
@onready var camera_target = $CameraRelativePosition
@onready var sprite := $AnimatedSprite3D
@onready var edge_detect : RayCast3D = $RayCast3D
var looking : String = "S"
const SPEED = 5.0

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("PlayerCamera")
	if camera:
		camera.target = camera_target
		#sprite.rotation.x = camera.rotation.x

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir.x > 0:
		if input_dir.y > 0:
			looking = "SE"
			pass #SE
		elif input_dir.y < 0:
			looking = "NE"
			pass #NE
		else:
			looking = "E"
			pass #E
	elif input_dir.x < 0:
		if input_dir.y > 0:
			looking = "SW"
			pass #SW
		elif input_dir.y < 0:
			looking = "NW"
			pass #NW
		else:
			looking = "W"
			pass #W
	else:
		if input_dir.y > 0:
			looking = "S"
			pass #S
		elif input_dir.y < 0:
			looking = "N"
			pass #N
	if input_dir != Vector2.ZERO:
		edge_detect.position = (Vector3(input_dir.x, -1, input_dir.y)).normalized() * 0.7
		edge_detect.force_raycast_update()
	if edge_detect.is_colliding():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			sprite.animation = "walk_" + looking
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			sprite.animation = "idle_" + looking
	else:
			velocity.x = 0
			velocity.z = 0
			sprite.animation = "idle_" + looking

	move_and_slide()
