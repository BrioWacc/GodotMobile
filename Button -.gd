extends Button

signal minus_pressed()

func _on_pressed():
	emit_signal("minus_pressed")

