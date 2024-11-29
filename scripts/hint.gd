extends Node2D

@onready var label : Label = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/Label

func set_text(msg):
	label.text = msg
