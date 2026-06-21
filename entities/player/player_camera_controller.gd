extends SpringArm3D


@export var mouse_sensibility: float = 0.005

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensibility
		rotation.x = clamp(rotation.x - event.relative.y * mouse_sensibility, deg_to_rad(-60), deg_to_rad(60))
