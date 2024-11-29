extends Control

@onready var value : Label = $CanvasLayer/PopupPanel/HBoxContainer/VBoxContainer/Value
@onready var type : String
signal done_pressed(value, type)

func set_type(types):
	self.type = types
	pass

func _on_plus_pressed():
	if (int(value.text) < 10): 
		value.text = str(int(value.text) + 1)
	pass

func _on_minus_pressed():
	if (int(value.text) > 1):
		value.text = str(int(value.text) - 1)
	pass

func _on_cancel_pressed():
	queue_free()
	pass

func _on_done_pressed():
	emit_signal("done_pressed", int(value.text), type)
	queue_free()
	pass
