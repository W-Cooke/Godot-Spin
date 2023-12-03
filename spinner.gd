extends Node2D

var is_stick_pressed = false
var is_spinning = false

@export var angle_threshold : float = 200.00

var current_angle : float = 0.0
var previous_angle : float = 0.0
var angle_list : Array = []
var spinning_clockwise = false
var spinning_anticlockwise = false
var list_size = 1

signal spinning_signal

func _process(_delta):
	controller_look()

#code for spinning!
func controller_look():
	# get joystick vector
	var stick_rotation: Vector2 = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
	# reverse stick value (so it’s pointing the right way)
	stick_rotation *= -1.0
	if stick_rotation.length() > 0.2:
		# convert to angle
		current_angle = stick_rotation.angle()
		current_angle = rad_to_deg(current_angle)
		# compare current angle to previous angle
		var angle_diff = previous_angle - current_angle
		# throw away angle differences if they’re too big a difference
		# this discounts the change that can happen between 179 to -179 or vice versa
		if (angle_diff >= angle_threshold) or (angle_diff <= -angle_threshold):
			pass
		else:
			angle_list.resize(list_size)
			angle_list.push_front(angle_diff)
			list_size += 1
	# check when list is long enough / enough time has passed
		if angle_list.size() > 20:
			# shoddy work but this removes the entry in the array that's <null>
			angle_list.resize(list_size - 1)
			var mean = calculate_mean(angle_list)
			# depending on if the average is positive or negative, plus past a certain threshold
			# slow spinning will mean the threshold will not get met
			if mean < -10:
				spinning_anticlockwise = true
				spinning_signal.emit("Anticlockwise")
			elif mean > 10:
				spinning_clockwise = true
				spinning_signal.emit("Clockwise")
	else:
		list_size = 1
		angle_list.resize(list_size)
		reset_bools()
		spinning_signal.emit("NO")
	# set previous angle 
	previous_angle = current_angle

func calculate_mean(list):
	var sum = 0.0
	var count = list.size()
	for i in list:
		sum += i
	var mean : float = sum / count
	return mean

func reset_bools():
	spinning_clockwise = false
	spinning_anticlockwise = false
