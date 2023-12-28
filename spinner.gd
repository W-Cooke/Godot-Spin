extends Node2D

@export var angle_threshold : float = 200.00

var current_angle : float = 0.0
var previous_angle : float = 0.0
var angle_array : Array = []
var spinning_clockwise : bool = false
var spinning_anticlockwise : bool = false
var array_size : int = 1

signal spinning_signal

func _process(_delta):
	controller_look()
	signal_bools()

#code for spinning!
func controller_look():
	# get joystick vector
	var stick_rotation: Vector2 = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
	# reverse stick value (so it’s pointing the right way)
	#stick_rotation *= -1.0
	if stick_rotation.length() > 0.2:
		# convert to angle
		current_angle = stick_rotation.angle()
		current_angle = rad_to_deg(current_angle)
		$TextureRect/TextureRect.rotation = deg_to_rad(current_angle - 90)
		# compare current angle to previous angle
		var angle_diff = previous_angle - current_angle
		# throw away angle differences if they’re too big a difference
		# this discounts the change that can happen between 179 to -179 or vice versa
		if (angle_diff >= angle_threshold) or (angle_diff <= -angle_threshold):
			pass
		else:
			angle_array.resize(array_size)
			angle_array.push_front(angle_diff)
			array_size += 1
		# check when list is long enough / enough time has passed
		if angle_array.size() > 21:
			# shoddy work but this removes the entry at the end of the array that's <null> (which prevents mean from being calculated properly)
			angle_array.resize(array_size - 1)
			var mean = calculate_mean(angle_array)
			# depending on if the average is positive or negative, plus past a certain threshold
			# slow spinning will mean the threshold will not get met
			if mean < -10:
				spinning_anticlockwise = true
			elif mean > 10:
				spinning_clockwise = true
			elif mean < 10 or mean > -10:
				reset_bools()
			# once the array reaches the threshold size and the logic has been applied the array is cleared
			# this allows spinning to be detected in either direction without having to reset to deadzone to reset the array
			array_size = 1
			angle_array.resize(array_size)
	else:
		# if stick input doesn't pass dead zone, variables are reset.
		array_size = 1
		angle_array.resize(array_size)
		reset_bools()
	# finally, set previous frame's angle to current angle
	previous_angle = current_angle

func calculate_mean(arr):
	var sum = 0.0
	var count = arr.size()
	for i in arr:
		sum += i
	var mean : float = sum / count
	return mean

func signal_bools():
	if spinning_clockwise:
		spinning_signal.emit("Clockwise")
	elif spinning_anticlockwise:
		spinning_signal.emit("Anticlockwise")
	else:
		spinning_signal.emit("NO")

func reset_bools():
	spinning_clockwise = false
	spinning_anticlockwise = false
