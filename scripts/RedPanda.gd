extends MeshInstance3D

var ui_scene: PackedScene
var ui_instance: Control 

func _ready():
	ui_scene = preload("res://scenes/Script_UI.tscn")
	pass

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		openGUi()
	pass

func openGUi():
	if(Manager.ui_active == false):
		Manager.ui_active = true
	else:
		return
		
	if ui_instance == null: 
		ui_instance = ui_scene.instantiate()
		get_parent().add_child(ui_instance)
		ui_instance.set_type("panda")
	ui_instance.show()
	pass
