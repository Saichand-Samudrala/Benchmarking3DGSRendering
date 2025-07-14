extends Camera3D

var ssCount := 0  # Screenshot counter
var radius := 1.2  # Radius of the circle
var center := Vector3(0, 0, 0)  # The point around which the camera rotates
var step := Vector3(0, 0.5, 0) # Steps for camera position updates
var angle := 0.0  # The initial angle (in radians)
var max_angle_degrees := 360  # Maximum angle in degrees (to capture images until full rotation)
var rotation_speed_degrees := 9  # Rotation speed in degrees per second

# Convert rotation speed to radians per second (since we're using radians for calculations)
var rotation_speed_radians := deg_to_rad(rotation_speed_degrees)

# List of initial positions and rotations (using an array of dictionaries)
var initial_configs = [
	{ "position": Vector3(0, -2, 1.2), "rotation": Vector3(-40, 0, 0) } # y from -2 to 3.1
]


@onready var dir := DirAccess.open("./")  # Path to save images

func _ready():
	print("Entering ready()")

	# Make sure the directory exists
	if !dir.file_exists("images"):
		dir.make_dir("images")

	# Perform the multiple runs with different initial positions and rotations
	for config in initial_configs:
		print(config)
		perform_iter(config)

func perform_iter(config):
	var initial_position = config["position"]
	var initial_rotation = config["rotation"]
	position = initial_position
	rotation = initial_rotation
	print(position.y)
	while position.y <= 3:
		angle = 0.0  # Reset the angle for each new run
		print("Performing run with position: " + str(position) + " and rotation: " + str(rotation))
		set_camera_position()
		await capture_screenshot()
		await start_rotation()
		position = position + step
		print(position.y)
		ssCount = ssCount + 1

func set_camera_position():
	# Set the camera's position in a circular path around the center point
	var x = center.x + radius * cos(angle)
	var z = center.z + radius * sin(angle)
	position = Vector3(x, position.y, z)

	# Apply the rotation to the camera and ensure it looks at the center
	look_at(center, Vector3.UP)

func start_rotation():
	# Start rotating and capturing images
	var max_angle_radians = deg_to_rad(max_angle_degrees)
	while angle < max_angle_radians:
		await get_tree().create_timer(0.1).timeout  # Wait for a brief moment
		capture_screenshot()
		rotate_camera()

	# Once the loop is done, stop capturing screenshots
	print("Completed a full rotation, stopping screenshot capture.")

func rotate_camera():
	# Rotate the camera around the center point by the rotation speed
	angle += rotation_speed_radians
	if angle >= deg_to_rad(max_angle_degrees):  # Stop once the maximum angle is reached
		angle = deg_to_rad(max_angle_degrees)
	
	# Update the camera position based on the new angle
	set_camera_position()
	
	# Increment the screenshot counter
	ssCount += 1

func capture_screenshot():
	print("Capturing screenshot #" + str(ssCount))
	
	# Wait for the frame to be drawn
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	
	# Save the image with a unique name
	var file_path = "./images/ss" + str(ssCount) + ".jpg"
	img.save_jpg(file_path, 90)
	
	print("Screenshot saved: " + file_path)
