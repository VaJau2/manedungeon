extends Node

class_name MovementController

var target: Vector2


func set_target(newTarget: Vector2) -> void:
	get_parent().global_position = newTarget
