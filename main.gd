extends Node

@onready var spin_label = $VBoxContainer/HBoxContainer/Label2
@onready var waggle_label = $VBoxContainer/HBoxContainer2/Label3

var spinning_clockwise = false
var spinning_anticlockwise = false

func _process(_delta):
	pass

func _on_spinner_spinning_signal(string):
	spin_label.text = string


func _on_waggler_waggle_signal(string):
	waggle_label.text = string
