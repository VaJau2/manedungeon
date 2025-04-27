extends Camera2D

#----------------------------------------------
# Отвечает за перемещение камеры и за зум
#-----------------------------------------------

const MAX_ZOOM: float = 5.0
const MIN_ZOOM: float = 1.0
const ZOOM_INCREMENT: float = 0.1
const ZOOM_RATE: float = 9.0
const KEY_MOVING_SPEED = 5.0

@onready var target_zoom = self.zoom.x
@export var player: CharacterBody2D


func _ready() -> void:
	var input_handler = get_tree().get_first_node_in_group("input_handler")
	input_handler.dragging.connect(dragging)
	input_handler.key_moving.connect(key_moving)
	input_handler.zoom_in.connect(zoom_in)
	input_handler.zoom_out.connect(zoom_out)


func _process(_delta: float) -> void:
	if G.settings.keys_moving == Enums.KeyMoving.player:
		global_position = player.global_position


func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, target_zoom))



func dragging(new_velocity: Vector2) -> void:
	if G.settings.keys_moving == Enums.KeyMoving.camera:
		translate(-new_velocity / zoom)


func key_moving(new_velocity: Vector2) -> void:
	if G.settings.keys_moving == Enums.KeyMoving.camera:
		translate(new_velocity / zoom * KEY_MOVING_SPEED)


func zoom_in() -> void:
	target_zoom = max(target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)


func zoom_out() -> void:
	target_zoom = min(target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)
