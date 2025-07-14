Copyright © 2017-present Hugo Locurcio and contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

extends Camera3D

# Constants for mouse sensitivity and movement parameters
const MOVE_SPEED_BASE = 0.5


# Adjustable camera settings
var move_speed := MOVE_SPEED_BASE
var motion := Vector3()
var velocity := Vector3()

# Initial camera rotation
var initial_rotation := rotation.y

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
		motion.y = 0

	if Input.is_action_pressed("move_left"):
		motion.z = 1
	elif Input.is_action_pressed("move_right"):
		motion.z = -1
	else:
		motion.z = 0

	# Add the motion to the velocity and apply damping (friction)
	velocity += motion * move_speed
	velocity *= 0.9

	# Update the camera's position
	position += velocity * delta
