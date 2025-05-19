extends Node2D

#-------------------------------------------------------------
# Спавнит комнаты через рекурсию
# Берет все комнаты из папки objects/rooms и расставляет их по локации
#-------------------------------------------------------------

@export var start_room_prefabs: Array[PackedScene]
var all_rooms: Array[Node2D]

# для ограничения количества спавна комнат
const MAX_ROOMS_COUNT: int = 4

# для того, чтобы локация не состояла всего из двух комнат
const MIN_MANY_EXITS_ROOMS_COUNT: int = 2

var rooms_count: int = 0
var many_exits_rooms_count: int = 0

# для фильтрации пересечений комнат
var busy_room_slots: Array[Vector2i]


func _ready() -> void:
	await get_tree().process_frame
	load_all_rooms()
	spawn_start_room()
	queue_free()


func load_all_rooms() -> void:
	var dir_path = "res://objects/rooms"
	var room_files_paths = DirAccess.get_files_at(dir_path)
	for file_path in room_files_paths:
		var room_prefab = load(dir_path + "/" + file_path)
		var room = room_prefab.instantiate()
		all_rooms.push_back(room)


func spawn_start_room() -> void:
	var room_index = randi_range(0, len(start_room_prefabs) - 1)
	var room = start_room_prefabs[room_index].instantiate()
	add_room(room, Vector2i.ZERO)
	room.global_position = global_position
	handle_room_exits(room, Vector2i.ZERO)


func handle_room_exits(room: Node2D, last_slot: Vector2i) -> void:
	var room_exits = room.get_node("room_exits").get_children()
	for my_exit in room_exits:
		if my_exit is RoomExit && my_exit.is_free:
			my_exit.is_free = false
			var next_slot = last_slot + get_slot_by_side(my_exit.next_room_side)
			var next_room = find_next_room(my_exit, next_slot)
			if next_room:
				spawn_next_room(next_room, my_exit, next_slot)


func find_next_room(my_exit: RoomExit, next_slot: Vector2i) -> Node2D:
	var filtered_rooms: Array[Node2D]
	for room in all_rooms:
		if filter_room(room, my_exit, next_slot):
			filtered_rooms.push_back(room)
	if filtered_rooms.is_empty(): return null
	return filtered_rooms[randi_range(0, len(filtered_rooms) - 1)]


func filter_room(room: Node2D, my_exit: RoomExit, next_slot: Vector2i) -> bool:
	var room_exits = room.get_node("room_exits").get_children()
	
	if many_exits_rooms_count < MIN_MANY_EXITS_ROOMS_COUNT && len(room_exits) == 1:
		return false
	
	if rooms_count >= MAX_ROOMS_COUNT && len(room_exits) > 1:
		return false
	
	var my_room_exit = find_other_room_exit(room, my_exit)
	
	if my_room_exit == null:
		return false
	
	for room_exit in room_exits:
		if room_exit == my_room_exit: continue
		var exit_slot = next_slot + get_slot_by_side(room_exit.next_room_side)
		if busy_room_slots.has(exit_slot):
			return false
	
	return true


func spawn_next_room(room: Node2D, my_exit: RoomExit, next_slot: Vector2i) -> void:
	all_rooms.erase(room)
	add_room(room, next_slot)
	var room_exit = find_other_room_exit(room, my_exit)
	room_exit.is_free = false
	var exit_position_delta = room.to_local(room_exit.global_position)
	var room_position = my_exit.global_position - exit_position_delta
	room.global_position = room_position
	handle_room_exits(room, next_slot)


func find_other_room_exit(room: Node2D, my_exit: RoomExit) -> RoomExit:
	var room_exits = room.get_node("room_exits").get_children()
	var other_exit_side = get_other_exit_side(my_exit.next_room_side)
	for room_exit in room_exits:
		if room_exit is RoomExit:
			if room_exit.next_room_side == other_exit_side:
				return room_exit
	return null


func add_room(room: Node2D, room_slot: Vector2i) -> void:
	get_parent().add_child(room)
	rooms_count += 1
	if room.get_node("room_exits").get_child_count() > 1:
		many_exits_rooms_count += 1
	busy_room_slots.push_back(room_slot)


func get_other_exit_side(side: Enums.ExitSide) -> Enums.ExitSide:
	match side:
		Enums.ExitSide.left:
			return Enums.ExitSide.right
		Enums.ExitSide.right:
			return Enums.ExitSide.left
		Enums.ExitSide.up:
			return Enums.ExitSide.down
		Enums.ExitSide.down:
			return Enums.ExitSide.up
	return Enums.ExitSide.left


func get_slot_by_side(side: Enums.ExitSide) -> Vector2i:
	match side:
		Enums.ExitSide.left:
			return Vector2i.LEFT
		Enums.ExitSide.right:
			return Vector2i.RIGHT
		Enums.ExitSide.up:
			return Vector2i.UP
		Enums.ExitSide.down:
			return Vector2i.DOWN
	return Vector2i.ZERO
