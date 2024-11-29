extends Node3D

@onready var title : PackedScene = load("res://scenes/title.tscn")
@onready var player_ui : PackedScene = preload("res://scenes/player_ui.tscn")
@onready var hint_ui : PackedScene = preload("res://scenes/hint.tscn")
@onready var redpanda = $RedPanda

var player_ui_instance
enum {NORTH, EAST, SOUTH, WEST}
var current_direction_index = 0
var initial_x
var initial_z
var Actions : int = 0

# 0 == water, 1 == land, 2 == goal
var map = [
	[0, 0, 0, 0, 0, 0, 0],
	[0, 1, 1, 1, 1, 1 ,0],
	[0, 1, 1, 1, 1, 1, 0],
	[0, 0, 0, 0, 1, 0, 0],
	[0, 2, 1, 1, 1, 0, 0],
	[0, 0, 0, 0, 0, 0, 0]
]

var panda_pos = [1, 1]

func _ready():
	player_ui_instance = player_ui.instantiate()
	add_child(player_ui_instance)
	
	player_ui_instance.connect("play_pressed", play_level)
	player_ui_instance.connect("reset_pressed", reset)
	player_ui_instance.connect("exit_pressed", exit)
	
	initial_x = redpanda.position.x
	initial_z = redpanda.position.z
	pass

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func play_level():
	if redpanda.ui_instance == null: return
	
	Actions += 1;
	
	player_ui_instance.lock_buttons(true)
	
	for child in redpanda.ui_instance.return_children():
		if child.type == "STEP":
			for i in range(child.quantity):
				if(current_direction_index == NORTH):
					redpanda.position.x += 2
					panda_pos[1] += 1
				elif(current_direction_index == SOUTH):
					redpanda.position.x -= 2
					panda_pos[1] -= 1
				elif(current_direction_index == EAST):
					redpanda.position.z += 2
					panda_pos[0] += 1
				elif(current_direction_index == WEST):
					redpanda.position.z -= 2
					panda_pos[0] -= 1
					
				await wait(0.3)
				
				if(map[panda_pos[0]][panda_pos[1]] == 0):
					call_hint("Der Panda ist ins Wasser gefallen!\n Achte darauf das er auf dem Land bleibt.");
					player_ui_instance.unlock_reset()
					break
					
				if(map[panda_pos[0]][panda_pos[1]] == 2):
					call_hint("Level Geschaft!\n du hast " + str(Actions) + " Zyklen benoetigt");
					player_ui_instance.unlock_reset()
					break
				
		elif child.type == "TURN":
			for i in range(child.quantity):
				redpanda.rotate_y(deg_to_rad(-90))
				current_direction_index += 1 
				current_direction_index %= 4
				await wait(0.3)
	
	player_ui_instance.unlock_reset()

func call_hint(msg: String):
	var hint_instance = hint_ui.instantiate()
	add_child(hint_instance)
	hint_instance.set_text(msg)
	

func reset():
	redpanda.position.x = initial_x
	redpanda.position.z = initial_z
	if(current_direction_index != 0):
		redpanda.rotate_y(deg_to_rad(-90*(4-current_direction_index)))
	
	current_direction_index = 0
	panda_pos=[1,1]
	
	if redpanda.ui_instance == null: return
	
	#for child in redpanda.ui_instance.return_children():
	#	child.queue_free()
	#pass
	
	player_ui_instance.hide_reset()
	player_ui_instance.lock_buttons(false)

func exit():
	get_tree().change_scene_to_packed(title)
