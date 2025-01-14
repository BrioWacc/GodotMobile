extends HBoxContainer

@onready var plus : Button = $"Button +"
@onready var minus : Button = $"Button -"
@onready var label : Label = $"Label Count"

func _ready():
	minus.connect("minus_pressed", _on_minus_pressed)

func _on_minus_pressed():
	var current_value = int(label.text)
	label.text = str(current_value - 1)
	
func _on_button__pressed():
	var current_value = int(label.text)
	label.text = str(current_value + 1)
