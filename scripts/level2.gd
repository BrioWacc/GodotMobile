extends Node3D

@onready var title : PackedScene = load("res://scenes/title.tscn")
@onready var player_ui : PackedScene = preload("res://scenes/player_ui.tscn")
@onready var hint_ui : PackedScene = preload("res://scenes/hint.tscn")
@onready var redpanda = $RedPanda
@onready var frog = $Frog
@onready var skip : bool = false;
var player_ui_instance
enum {NORTH, EAST, SOUTH, WEST}
var Actions : int = 0
var panda_current_direction_index = [0]
var frog_current_direction_index = [3]
var panda_initial_x
var panda_initial_z
var frog_initial_x
var frog_initial_z

var map = [
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 1, 1, 1, 0, 0, 0, 0],
	[0, 1, 1, 1, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 0, 0, 0, 0],
	[0, 0, 0, 0, 1, 1, 1, 1, 0],
	[0, 0, 0, 0, 0, 3, 3, 3, 0],
	[0, 0, 0, 0, 0, 0, 3, 3, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
	[0, 0, 0, 0, 0, 0, 4, 0, 0],
	[0, 0, 0, 0, 0, 0, 0, 0, 0],
]

var panda_start_pos = [3, 1]
var panda_pos = panda_start_pos.duplicate()
var frog_start_pos = [6, 7]
var frog_pos = frog_start_pos.duplicate()
var spot = [7, 6]
var goal = [1, 4]

func _ready():
	player_ui_instance = player_ui.instantiate()
	add_child(player_ui_instance)
	
	player_ui_instance.connect("play_pressed", play_level)
	player_ui_instance.connect("reset_pressed", reset)
	player_ui_instance.connect("exit_pressed", exit)
	
	panda_initial_x = redpanda.position.x
	panda_initial_z = redpanda.position.z
	
	frog_initial_x = frog.position.x
	frog_initial_z = frog.position.z

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func play_level():
	if redpanda.ui_instance == null or frog.ui_instance == null: return
	player_ui_instance.lock_buttons(true)
	
	var redpanda_instructions = redpanda.ui_instance.return_children()
	var frog_instructions = frog.ui_instance.return_children()
	
	var max_steps = max(redpanda_instructions.size(), frog_instructions.size())
	
	for step in range(max_steps):
		if step < redpanda_instructions.size():
			if skip:
				skip = false
				continue
				
			if(step+1 < redpanda_instructions.size()):
				await execute_step(redpanda, redpanda_instructions[step], panda_pos, panda_current_direction_index, redpanda_instructions[step+1])

			else: await execute_step(redpanda, redpanda_instructions[step], panda_pos, panda_current_direction_index)
		
		if step < frog_instructions.size():
			await execute_step(frog, frog_instructions[step], frog_pos, frog_current_direction_index)
	
	if(panda_pos == goal and map[goal[0]][goal[1]] == 2):
		call_hint("Level geschafft!\n Du hast " + str(Actions) + " Zyklen benoetigt.")
	
	player_ui_instance.unlock_reset()
		
func execute_step(character, instruction, position, direction_index, job=null):
	Actions += 1;
	if instruction.type == "STEP":
		for i in range(instruction.quantity):
			if direction_index[0] == NORTH:
				character.position.x += 2
				position[1] += 1
			elif direction_index[0] == SOUTH:
				character.position.x -= 2
				position[1] -= 1
			elif direction_index[0] == EAST:
				character.position.z += 2
				position[0] += 1
			elif direction_index[0] == WEST:
				character.position.z -= 2
				position[0] -= 1
			
			await wait(0.3)
			var tile = map[position[0]][position[1]]
			if tile == 0:
				call_hint("der " + character.obj_name + " ist ins Wasser gefallen!\n Achte darauf das er auf dem Land bleibt.")
				player_ui_instance.unlock_reset()
				return false
			elif tile == 2:
				call_hint("Level geschafft!\n Du hast " + str(Actions) + " Zyklen benötigt.")
				player_ui_instance.unlock_reset()
				return true
	
	elif instruction.type == "TURN":
		for i in range(instruction.quantity):
			character.rotate_y(deg_to_rad(-90))
			direction_index[0] += 1
			direction_index[0] %= 4
			await wait(0.3)
			
	elif instruction.type == "TONGUE":
		if(position == spot):
			map[goal[0]][goal[1]] = 2
		await wait(0.3)
		
	else:
		skip = true
		if instruction.type == "WHILE LAND INFRONT":
			if direction_index[0] == NORTH:
				while(map[position[0]][position[1] + 1] == 1):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(map[position[0]][position[1] - 1] == 1):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(map[position[0]][position[0] + 1] == 1):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(map[position[0]][position[0] - 1] == 1):
					await execute_step(character, job, position, direction_index)
				
		elif instruction.type == "WHILE LAND BEHIND":
			if direction_index[0] == NORTH:
				while(map[position[0]][position[1] - 1] == 1):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(map[position[0]][position[1] + 1] == 1):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(map[position[0]][position[0] - 1] == 1):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(map[position[0]][position[0] + 1] == 1):
					await execute_step(character, job, position, direction_index)
					
		elif instruction.type == "WHILE WATER INFRONT":
			if direction_index[0] == NORTH:
				while(map[position[0]][position[1] + 1] == 0):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(map[position[0]][position[1] - 1] == 0):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(map[position[0]][position[0] + 1] == 0):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(map[position[0]][position[0] - 1] == 0):
					await execute_step(character, job, position, direction_index)

		elif instruction.type == "WHILE WATER BEHIND":
			if direction_index[0] == NORTH:
				while(map[position[0]][position[1] - 1] == 0):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(map[position[0]][position[1] + 1] == 0):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(map[position[0]][position[0] - 1] == 0):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(map[position[0]][position[0] + 1] == 0):
					await execute_step(character, job, position, direction_index)
					
		elif instruction.type == "WHILE LAND NOT INFRONT":
			if direction_index[0] == NORTH:
				while(!(map[position[0]][position[1] + 1] == 1)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(!(map[position[0]][position[1] - 1] == 1)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(!(map[position[0]][position[0] + 1] == 1)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(!(map[position[0]][position[0] - 1] == 1)):
					await execute_step(character, job, position, direction_index)
					
		elif instruction.type == "WHILE LAND NOT BEHIND":
			if direction_index[0] == NORTH:
				while(!(map[position[0]][position[1] - 1] == 1)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(!(map[position[0]][position[1] + 1] == 1)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(!(map[position[0]][position[0] - 1] == 1)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(!(map[position[0]][position[0] + 1] == 1)):
					await execute_step(character, job, position, direction_index)
					
		elif instruction.type == "WHILE WATER NOT INFRONT":
			if direction_index[0] == NORTH:
				while(!(map[position[0]][position[1] + 1] == 0)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(!(map[position[0]][position[1] - 1] == 0)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(!(map[position[0]][position[0] + 1] == 0)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(!(map[position[0]][position[0] - 1] == 0)):
					await execute_step(character, job, position, direction_index)
					
		elif instruction.type == "WHILE WATER NOT BEHIND":
			if direction_index[0] == NORTH:
				while(!(map[position[0]][position[1] - 1] == 0)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == SOUTH:
				while(!(map[position[0]][position[1] + 1] == 0)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == EAST:
				while(!(map[position[0]][position[0] - 1] == 0)):
					await execute_step(character, job, position, direction_index)
			elif direction_index[0] == WEST:				
				while(!(map[position[0]][position[0] + 1] == 0)):
					await execute_step(character, job, position, direction_index)
	return false

func call_hint(msg: String):
	var hint_instance = hint_ui.instantiate()
	add_child(hint_instance)
	hint_instance.set_text(msg)

func reset():
	redpanda.position.x = panda_initial_x
	redpanda.position.z = panda_initial_z
	
	var panda_rotation_steps = (4 - panda_current_direction_index[0]) % 4
	for i in range(panda_rotation_steps):
		redpanda.rotate_y(deg_to_rad(-90))
		
	panda_current_direction_index[0] = 0
	panda_pos = panda_start_pos.duplicate()
	
	frog.position.x = frog_initial_x
	frog.position.z = frog_initial_z
	
	var frog_rotation_steps = (3 - frog_current_direction_index[0]) % 4
	
	for i in range(frog_rotation_steps):
		frog.rotate_y(deg_to_rad(-90))
	
	frog_current_direction_index[0] = 3
	frog_pos = frog_start_pos.duplicate()
	
	player_ui_instance.hide_reset()
	player_ui_instance.lock_buttons(false)

func exit():
	get_tree().change_scene_to_packed(title)
