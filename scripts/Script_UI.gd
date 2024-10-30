extends Control

const code_lines : PackedScene = preload("res://scenes/code_line.tscn")
@onready var code_cols : VBoxContainer = $ScriptBG/CodingArea/PanelContainer/ScrollContainer/code_cols

func set_type(type: String):
	if type == "panda":
		$ScriptBG/PandaHBox.show()
	elif type == "frog":
		$ScriptBG/FrogHBox.show()
	else:
		print("attempted to load unknown ui type " + type)
		get_tree().quit()
	pass

func _on_step_pressed():
	var temp = code_lines.instantiate()
	temp.set_type("STEP")
	code_cols.add_child(temp)
	pass

func _on_turn_pressed():
	var temp = code_lines.instantiate()
	temp.set_type("TURN")
	code_cols.add_child(temp)
	pass

func _on_tongue_pressed():
	var temp = code_lines.instantiate()
	temp.set_type("TONGUE", 2)
	code_cols.add_child(temp)
	pass

func _on_clear_pressed():
	for child in code_cols.get_children():
		child.queue_free()
	pass

func _on_exit_pressed():
	self.hide()
	Manager.ui_active = false
	pass
