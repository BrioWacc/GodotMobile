extends CenterContainer

@onready var level1 : PackedScene = preload("res://scenes/test_level.tscn")
@onready var level2 : PackedScene = preload("res://scenes/level2.tscn")

func _process(_delta):
	self.size.x = DisplayServer.window_get_size().x
	self.size.y = DisplayServer.window_get_size().y

func _on_l_1_pressed():
	get_tree().change_scene_to_packed(level1)

func _on_l_2_pressed():
	get_tree().change_scene_to_packed(level2)
