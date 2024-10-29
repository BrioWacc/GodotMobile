extends Control

var ui_type: String
var hbox
var manager

func set_type(type: String):
	ui_type = type
	if ui_type == "panda":
		hbox = $ScriptBG/PandaHBox
	elif ui_type == "frog":
		hbox = $ScriptBG/FrogHBBox
	else:
		print("attempted to load unknown ui type " + type)
		get_tree().quit()
		
	hbox.show()

func hideMenu():
	self.hide()
	Manager.ui_active = false
	pass
