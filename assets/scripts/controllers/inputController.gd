extends Node

@export var movement_controller: MovementController
var input_handler: InputHandler
var is_key_moving: bool = false


func _ready() -> void:
	input_handler = get_tree().get_first_node_in_group("input_handler")
	input_handler.click.connect(_on_click)
	input_handler.key_running.connect(_on_running)
	input_handler.key_crouching.connect(_on_crouching)


func _on_click(pos: Vector2) -> void:
	movement_controller.set_target(pos)


func _on_running() -> void:
	var state = movement_controller.current_state.name
	movement_controller.load_state("run" if state != "run" else "walk")


func _on_crouching() -> void:
	var state = movement_controller.current_state.name
	movement_controller.load_state("crouch" if state != "crouch" else "walk")


func _physics_process(_delta: float) -> void:
	if G.settings.keys_moving != Enums.KeyMoving.player: return
	
	if input_handler.get_dir().length() > 0:
		is_key_moving = true
		movement_controller.set_velocity(input_handler.get_dir() * movement_controller.current_state.speed)
		if movement_controller.is_navigating():
			movement_controller.stop_navigation()
	elif is_key_moving:
		is_key_moving = false
		movement_controller.set_velocity(Vector2.ZERO)
