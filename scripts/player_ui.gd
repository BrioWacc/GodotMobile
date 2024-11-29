extends Control

signal play_pressed()
signal reset_pressed()
signal exit_pressed()

@onready var play_button : Button = $HBoxContainer/Play
@onready var reset_button : Button = $Reset
@onready var exit_button : Button = $HBoxContainer/Exit

func _ready():
	reset_button.hide()

func _on_play_pressed():
	emit_signal("play_pressed")

func _on_reset_pressed():
	emit_signal("reset_pressed")

func _on_exit_pressed():
	emit_signal("exit_pressed")

func lock_buttons(state: bool):
	play_button.disabled = state
	exit_button.disabled = state
	
func unlock_reset():
	reset_button.show()
	
func hide_reset():
	reset_button.hide()
