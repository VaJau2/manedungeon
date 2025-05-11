extends TileMapLayer

const MAP_SIZE: int = 200
const MIN_VELOCITY: float = 2.0
const ERASE_RADIUS: int = 6

@export var player_spawner: PlayerSpawner
var player: CharacterBody2D


func _ready() -> void:
	set_process(false)
	player_spawner.player_loaded.connect(_on_player_loaded)
	@warning_ignore("integer_division")
	for x in range(-MAP_SIZE / 2, MAP_SIZE / 2):
		@warning_ignore("integer_division")
		for y in range(-MAP_SIZE / 2, MAP_SIZE / 2):
			set_cell(Vector2i(x, y), 0, Vector2i(0, 0))


func _process(_delta: float) -> void:
	if player.velocity.length() > MIN_VELOCITY:
		update_tile_by_player()


func _on_player_loaded(new_player: CharacterBody2D) -> void:
	player = new_player
	update_tile_by_player()
	set_process(true)


func update_tile_by_player() -> void:
	var radius = ERASE_RADIUS
	var player_pos = local_to_map(to_local(player.global_position))
	
	for y_offset in range(-radius, radius + 1):
		for x_offset in range(-radius, radius + 1):
			var offset := Vector2i(x_offset, y_offset)
			if offset.length() <= radius:
				erase_cell(player_pos + offset)
