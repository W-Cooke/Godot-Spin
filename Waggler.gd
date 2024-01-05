extends Node

#TODO: attach waggle script to check for waggle
var waggle_array = []
var is_spinning : bool = false
var is_waggling : bool = false
signal waggle_signal

func waggle():
	var stick_rotation: Vector2 = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
	if stick_rotation.y > 0.2 or stick_rotation.y < -0.2:
		waggle_array.push_front(stick_rotation.y)
	if waggle_array.size() > 21:
		# same hacky method to get ride of one null value at beginning of array ¯\_(ツ)_/¯
		waggle_array.resize(20)
		print(is_spinning)
		waggle_array.resize(1)
		# TODO: calculate threshold for detecting waggle, implement waggle script
		# TODO: look up array methods to figure this out
		# TODO: potential solution - only log to array if value is 1 or -1
		#		clear array after certain number of frames have passed.
		#		if array has gone up to size in that time, then we need to
		#		find a way to calcuate how many 1s and -1s there are in the array

func _process(_delta):
	waggle()

func reset_bools():
	is_waggling = false

func signal_bools():
	if is_waggling:
		waggle_signal.emit("YES")
	else:
		waggle_signal.emit("NO")

func _on_spinner_spinning_signal(string):
	# ensures that waggle script won't execute when stick is spinning
	if string == "NO":
		is_spinning = false
	else:
		is_spinning = true
