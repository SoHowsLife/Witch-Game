extends CharacterBody3D

var camera : Camera3D
@onready var camera_target = $CameraRelativePosition
@onready var sprite : Sprite3D = $Sprite3D
@onready var edge_detect : RayCast3D = $RayCast3D
const SPEED = 5.0

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("PlayerCamera")
	if camera:
		camera.target = camera_target
		sprite.rotation.x = camera.rotation.x

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir != Vector2.ZERO:
		edge_detect.position = (Vector3(input_dir.x, -1, input_dir.y)).normalized() * 0.7
		edge_detect.force_raycast_update()
	if edge_detect.is_colliding():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
			velocity.x = 0
			velocity.z = 0

	move_and_slide()
