extends Control

const code_lines : PackedScene = preload("res://scenes/code_line.tscn")
const popups : PackedScene = preload("res://scenes/popup.tscn")
const while_popup : PackedScene = preload("res://scenes/while_popup.tscn")
const if_popup : PackedScene = preload("res://scenes/if_popup.tscn")
@onready var code_cols : VBoxContainer = $ScriptBG/CodingArea/PanelContainer/ScrollContainer/code_cols

func set_type(type: String):
	if type == "panda":
		$ScriptBG/PandaHBox.show()
	elif type == "frog":
		$ScriptBG/FrogHBox.show()
	else:
		print("attempted to load unknown ui type " + type)
		get_tree().quit()

func disable_WHILE(type: String):
	if type == "panda":
		$ScriptBG/PandaHBox/While.hide()
	elif type == "frog":
		$ScriptBG/FrogHBox/While.hide()
	else:
		print("attempted to hide while of " + type)
		
func disable_IF(type: String):
	if type == "panda":
		$ScriptBG/PandaHBox/if.hide()
	elif type == "frog":
		$ScriptBG/FrogHBox/if.hide()
	else:
		print("attempted to hide if of " + type)

func _on_step_pressed():
	var popup_instance = popups.instantiate()
	popup_instance.set_type("STEP")
	add_child(popup_instance)
	popup_instance.connect("done_pressed", _on_popup_done)

func _on_turn_pressed():
	var popup_instance = popups.instantiate()
	popup_instance.set_type("TURN")
	add_child(popup_instance)
	popup_instance.connect("done_pressed", _on_popup_done)

func _on_tongue_pressed():
	var popup_instance = popups.instantiate()
	popup_instance.set_type("TONGUE")
	add_child(popup_instance)
	popup_instance.connect("done_pressed", _on_popup_done)

func _on_while_pressed():
	var while_popup_instance = while_popup.instantiate()
	add_child(while_popup_instance)
	while_popup_instance.connect("while_done_pressed", _on_while_popup_done)
	pass

func _on_if_pressed():
	var if_popup_instance = if_popup.instantiate()
	add_child(if_popup_instance)
	if_popup_instance.connect("if_done_pressed", _on_if_popup_done)
	pass

func _on_popup_done(value, type):
	var temp = code_lines.instantiate()
	temp.set_type(type, value)
	code_cols.add_child(temp)
	
func _on_while_popup_done(type):
	var temp = code_lines.instantiate()
	temp.set_type(type, 1)
	code_cols.add_child(temp)
	
func _on_if_popup_done(type):
	var temp = code_lines.instantiate()
	temp.set_type(type, 1)
	code_cols.add_child(temp)
	
func _on_clear_pressed():
	for child in code_cols.get_children():
		child.queue_free()

func _on_exit_pressed():
	self.hide()
	Manager.ui_active = false

func return_children():
	return code_cols.get_children()

func _on_delete_pressed():
	var children = code_cols.get_children()
	if children.size() > 0:
		code_cols.get_children()[-1].queue_free()
