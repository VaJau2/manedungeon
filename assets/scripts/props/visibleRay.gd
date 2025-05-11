extends RayCast2D

#----------------------------------------------
# Скрывает объект, если он не видит игрока
#-----------------------------------------------

@onready var parent = get_parent()
var player: CharacterBody2D

@export var custom_parent: StaticBody2D


func _ready() -> void:
	set_process(false)
	var player_spawner: PlayerSpawner = get_tree().get_first_node_in_group("player_spawner")
	player_spawner.player_loaded.connect(_on_player_loaded)


func _on_player_loaded(new_player: CharacterBody2D) -> void:
	player = new_player
	set_process(true)


func get_ray_parent() -> StaticBody2D:
	if custom_parent != null:
		return custom_parent
	return parent


func _process(_delta: float) -> void:
	target_position = player.global_position - global_position
	var collider_body = get_collider()
	get_ray_parent().visible = collider_body == player
