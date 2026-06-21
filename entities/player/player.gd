extends CharacterBody3D

@export var speed := 8.0
@export var turnSPeed := 30

# smooth transition for when start/stop move
@export var acceleration := 25.0
@export var friction := 25.0

# jump/gravity
@export var jumpForce := 8.0
@export var fall_gravity_multiplier := 1.8
@export var low_jump_multiplier := 2.5 # for short jump
@export var air_friction := 1.0
@export var coyote_time := 0.5

var coyote_timer := coyote_time

@onready var model: MeshInstance3D = $Model
@onready var third_person_camera: Camera3D = $SpringArm3D/Camera3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# gravity
	var gravity_mutilplier := 1.0
	if velocity.y < 0:
		gravity_mutilplier = fall_gravity_multiplier 
	# for lower jump
	elif velocity.y > 0 and not Input.is_action_pressed("jump"):
		gravity_mutilplier = low_jump_multiplier
	
	# in the air
	if not is_on_floor():
		velocity.y -= gravity * gravity_mutilplier * delta
		velocity.x *= air_friction
		velocity.z *= air_friction
		
		coyote_timer -= delta
	else:
		coyote_timer = coyote_time
	
	# jump 
	if coyote_timer > 0.0 and Input.is_action_just_pressed("jump"):
		velocity.y = jumpForce 
	
	# camera direction	
	var cam_forward := -third_person_camera.global_transform.basis.z
	var cam_right := third_person_camera.global_transform.basis.x
	cam_forward.y = 0
	cam_right.y = 0
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()
	
	# input direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	# final direction	
	var direction := (cam_right * input_dir.x + cam_forward * -input_dir.y).normalized()
	
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
