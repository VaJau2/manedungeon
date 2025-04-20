extends Node

@export var movementController: MovementController


func _ready() -> void:
	var mouseHandler = get_tree().get_first_node_in_group("mouse_handler")
	mouseHandler.click.connect(click)


func click(pos: Vector2) -> void:
	movementController.set_target(pos)
