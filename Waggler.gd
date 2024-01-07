extends Node

#TODO: add notes

@export var array_size : int = 20
var waggle_array = [0.0]
var is_spinning : bool = false
var is_waggling : bool = false
var state_change : bool = false
signal waggle_signal


var one_count : int
var minus_one_count : int
var threshold_reached : bool
@export var edge_threshold : int = 4

func waggle():
	var stick_rotation: Vector2 = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y), Input.get_joy_axis(0, JOY_AXIS_RIGHT_X))
	# if the stick is pushed all the way to either left or right the script will register it and add it to the 
	if stick_rotation.y == 1 or stick_rotation.y == -1:
		waggle_array.push_front(stick_rotation.y)
	else:
		waggle_array.push_front(0.0)
	if waggle_array.size() > array_size:
		one_count = waggle_array.count(1.0)
		minus_one_count = waggle_array.count(-1.0)
		threshold_reached = (one_count > edge_threshold and minus_one_count > edge_threshold)
		if threshold_reached:
			print("HOOOUUGHH IT'S A WAGGLE!")
			is_waggling = true
			state_change = true
		elif not threshold_reached and state_change:
			state_change = false
		else:
			reset_bools()
		waggle_array.resize(1)

func _process(_delta):
	waggle()
	signal_bools()

func reset_bools():
	is_waggling = false
	threshold_reached = false

func signal_bools():
	if is_waggling:
		waggle_signal.emit("WAGGLIN'")
	else:
		waggle_signal.emit("NO")

func _on_spinner_spinning_signal(string):
	# ensures that waggle script won't execute when stick is spinning
	if string == "NO":
		is_spinning = false
	else:
		is_spinning = true
