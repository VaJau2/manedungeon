extends Node

@export var movement_controller: MovementController
var input_handler: InputHandler
var is_key_moving: bool = false


func _ready() -> void:
	input_handler = get_tree().get_first_node_in_group("input_handler")
	input_handler.click.connect(click)


func click(pos: Vector2) -> void:
	movement_controller.set_target(pos)


func _physics_process(_delta: float) -> void:
	if G.settings.keys_moving != Enums.KeyMoving.player: return
	
	if input_handler.get_dir().length() > 0:
		is_key_moving = true
		movement_controller.set_velocity(input_handler.get_dir() * 100)
		if movement_controller.is_navigating():
			movement_controller.stop_navigation()
	elif is_key_moving:
		is_key_moving = false
		movement_controller.set_velocity(Vector2.ZERO)
