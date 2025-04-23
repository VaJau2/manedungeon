extends Node

#------------------
# При клике мышкой
#------------------

@export var line_prefab: PackedScene
@export var nav_agent: NavigationAgent2D
@export var movement_controller: MovementController

var line: Line2D


func _ready() -> void:
	nav_agent.path_changed.connect(show_line)
	movement_controller.stop.connect(hide_line)


func show_line() -> void:
	if line: line.queue_free()
	line = line_prefab.instantiate()
	line.player = get_parent()
	var lineParent = get_node("../../")
	lineParent.add_child(line)
	line.points = nav_agent.get_current_navigation_path()
	var point = line.get_node("point")
	point.global_position = nav_agent.get_final_position()


func hide_line() -> void:
	if line: line.queue_free()
