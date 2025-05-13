extends Node2D

class_name PlayerSpawner

@export var player_prefab: PackedScene

signal player_loaded(player: CharacterBody2D)

func _ready() -> void:
	await get_tree().process_frame
	var player: CharacterBody2D = player_prefab.instantiate()
	get_parent().add_child(player)
	player.global_position = global_position
	await get_tree().process_frame
	player_loaded.emit(player)
	queue_free()
