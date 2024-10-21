extends MeshInstance3D

var start_pos_x 
var start_pos_y 
var start_pos_z 
var falling = false
# Called when the node enters the scene tree for the first time.
func _ready():
	start_pos_x = position.x
	start_pos_y = position.y
	start_pos_z = position.z
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if falling == false:
		if position.x <= 0:
			position.x = start_pos_x
			position.y = 20
			falling = true
		else:
			position.x -= 0.1
	else:
		if position.y > start_pos_y:
			position.y -= 0.1
		else:
			falling = false;
	pass
