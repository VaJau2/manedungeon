extends Node2D

@export var spawn_chance: float = 1.0

func _ready() -> void:
	if randf() > spawn_chance:
		queue_free()
		return
	
	await get_tree().process_frame
	var dir_path = "res://objects/props/furniture"
	var furn_files_paths = DirAccess.get_files_at(dir_path)
	var rand_index = randi_range(0, len(furn_files_paths) - 1)
	var furn_prefab = load(dir_path + "/" + furn_files_paths[rand_index])
	var furn = furn_prefab.instantiate()
	get_parent().add_child(furn)
	furn.global_position = global_position
	queue_free()
