extends Node

@export var movement_controller: MovementController


func _ready() -> void:
	var mouse_handler = get_tree().get_first_node_in_group("mouse_handler")
	mouse_handler.click.connect(click)


func click(pos: Vector2) -> void:
	movement_controller.set_target(pos)
