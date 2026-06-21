extends CharacterBody3D

@export var speed: float = 8.0
@export var jumpForce: float = 4.0
@export var acceleration: float = 25.0
@export var friction: float = 25.0
@export var airControl: float = 0.25
@export var turnSPeed: float = 30

@onready var model: MeshInstance3D = $Model
@onready var third_person_camera: Camera3D = $SpringArm3D/Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.x *= airControl
		velocity.z *= airControl
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jumpForce 
	
	# camera direction	
	var cam_forward := -third_person_camera.global_transform.basis.z
	var cam_right := third_person_camera.global_transform.basis.x
	cam_forward.y = 0
	cam_right.y = 0
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()
	
	# input direction
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# final direction	
	var direction: Vector3 = Vector3(cam_right * input_dir.x + cam_forward * -input_dir.y).normalized()
	
	# movement itself
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)
	
	# rotate model
	if direction:
		var target_angle := atan2(-direction.x, -direction.z);
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, turnSPeed * delta)

	
	move_and_slide()
	
