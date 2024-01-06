extends Node

#TODO: attach waggle script to check for waggle
@export var array_size : int = 20
var waggle_array = [0.0]
var is_spinning : bool = false
var is_waggling : bool = false
signal waggle_signal

func waggle():
	var stick_rotation: Vector2 = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
	# if the stick is pushed all the way to either left or right the script will register it and add it to the 
	if stick_rotation.y == 1 or stick_rotation.y == -1:
		waggle_array.push_front(stick_rotation.y)
	else:
		waggle_array.push_front(0.0)
	if waggle_array.size() > array_size + 1:
		# same hacky method to get ride of one null value at beginning of array ¯\_(ツ)_/¯
		waggle_array.resize(array_size)
		print(is_spinning)
		waggle_array.resize(1)
		# TODO: calculate threshold for detecting waggle, implement waggle script
		# TODO: look up array methods to figure this out
		# TODO: potential solution - only log to array if value is 1 or -1
		#		clear array after certain number of frames have passed.
		#		if array has gone up to size in that time, then we need to
		#		find a way to calcuate how many 1s and -1s there are in the array
		#		count(int) method for arrays will return an int of how many times it appears in the array

func _process(_delta):
	waggle()
	signal_bools()

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
