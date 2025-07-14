extends Camera3D

# Constants for mouse sensitivity and movement parameters
const MOVE_SPEED_BASE = 0.5


# Adjustable camera settings
var move_speed := MOVE_SPEED_BASE
var motion := Vector3()
var velocity := Vector3()

@onready var fps_counter := $"../FPSCounter" as Label

# Called every frame
func _process(delta: float) -> void:
# Determine movement direction based on user input
	if Input.is_action_pressed("move_forward"):
		motion.x = -1
	elif Input.is_action_pressed("move_backward"):
		motion.x = 1
	else:
		motion.x = 0

	if Input.is_action_pressed("move_up"):
		motion.y = -1
	elif Input.is_action_pressed("move_down"):
		motion.y = 1
	else:
		motion.y = 0.
		

	if Input.is_action_pressed("move_left"):
		motion.z = 1
	elif Input.is_action_pressed("move_right"):
		motion.z = -1
	else:
		motion.z = 0

	velocity += motion * move_speed
	velocity *= 0.9

	# Update the camera's position
	position += velocity * delta
