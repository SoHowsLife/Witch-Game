extends CharacterBody3D

var camera : Camera3D
@onready var camera_target = $CameraRelativePosition
@onready var sprite := $AnimatedSprite3D
@onready var v_edge := $Vertical
@onready var h_edge := $Horizontal
@onready var interact_area := $InteractArea
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
	if input_dir != Vector2.ZERO:
		looking = ""
		if input_dir.y > 0:
			looking = "S"
			v_edge.position = (Vector3(0, -1, 1)).normalized()
		elif input_dir.y < 0:
			looking = "N"
			v_edge.position = (Vector3(0, -1, -1)).normalized()
		if input_dir.x > 0:
			looking += "E"
			h_edge.position = (Vector3(1, -1, 0)).normalized()
		elif input_dir.x < 0:
			looking += "W"
			h_edge.position = (Vector3(-1, -1, 0)).normalized()
		v_edge.force_raycast_update()
		h_edge.force_raycast_update()
	if direction:
		if h_edge.is_colliding():
			velocity.x = direction.x * SPEED
		else:
			velocity.x = 0
		if v_edge.is_colliding():
			velocity.z = direction.z * SPEED
		else:
			velocity.z = 0
		sprite.animation = "walk_" + looking
	else:
		if h_edge.is_colliding() || v_edge.is_colliding():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		else:
			velocity.x = 0
			velocity.z = 0
		sprite.animation = "idle_" + looking
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if interact_area.has_overlapping_bodies():
			for body in interact_area.get_overlapping_bodies():
				if body is Interactable:
					body.interact()
					break


func _on_interact_area_body_entered(body: Node3D) -> void:
	print("TEST ENTER ", body)

func _on_interact_area_body_exited(body: Node3D) -> void:
	print("TEST EXIT ", body)
