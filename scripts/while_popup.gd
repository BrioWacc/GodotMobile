extends Control

@onready var type : String = "WHILE"
@onready var LAND : Button = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/LAND
@onready var WATER : Button = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/WATER
@onready var INFRONT : Button = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/INFRONT
@onready var BEHIND : Button = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/BEHIND
@onready var NOT : Button = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/NOT

signal while_done_pressed(type)

var land : bool = true
var behind : bool = true
var water : bool = false
var infront : bool = false
var not_b : bool = false

func _ready():
	LAND.button_pressed = true
	BEHIND.button_pressed = true

func _on_cancel_pressed():
	queue_free()

func _on_done_pressed():
	if land:
		type += " LAND"
	else:
		type += " WATER"
	
	if not_b:
		type += " NOT"
	
	if behind:
		type += " BEHIND"
	else:
		type += " INFRONT"
	
	emit_signal("while_done_pressed", type)
	queue_free()

func _on_land_toggled(toggled_on):
	land = toggled_on
	water = false
	if toggled_on:
		WATER.button_pressed = false

func _on_water_toggled(toggled_on):
	water = toggled_on
	land = false
	if toggled_on:
		LAND.button_pressed = false

func _on_infront_toggled(toggled_on):
	infront = toggled_on
	if toggled_on:
		behind = false
		BEHIND.button_pressed = false

func _on_behind_toggled(toggled_on):
	behind = toggled_on
	if toggled_on:
		infront = false
		INFRONT.button_pressed = false

func _on_not_toggled(toggled_on):
	not_b = toggled_on
