extends MeshInstance3D

const ui_scene: PackedScene = preload("res://scenes/Script_UI.tscn")
var ui_instance: Control
var obj_name = "Panda"
var level = "2"

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		openGUi()
	pass

func openGUi():
	if Manager.ui_active:
		return
	
	Manager.ui_active = true

	if ui_instance == null:
		ui_instance = ui_scene.instantiate()
		get_tree().current_scene.add_child(ui_instance) 
		ui_instance.set_type("panda")
		if level == "1": ui_instance.disable_WHILE("panda")
	ui_instance.show()
	
	pass
