extends CharacterBody3D

@export var speed: float = 8.0
@export var jumpForce: float = 4.0
@export var acceleration: float = 25.0
@export var friction: float = 25.0
@export var airControl: float = 0.25

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		velocity.x *= airControl
		velocity.z *= airControl
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jumpForce 
	
	# smooth movement
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)
	
	move_and_slide()
	
