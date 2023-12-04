extends Node

@onready var spin_label = $VBoxContainer/Label2

var spinning_clockwise = false
var spinning_anticlockwise = false

func _process(_delta):
	pass

func _on_spinner_spinning_signal(string):
	spin_label.text = string
