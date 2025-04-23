extends Node

class_name MovementController

@onready var parent: CharacterBody2D = get_parent()
@export var nav_agent: NavigationAgent2D
@export var movement_speed = 100

signal move
signal stop

var target: Vector2


func set_target(newTarget: Vector2) -> void:
	nav_agent.target_position = newTarget
	move.emit()
	set_physics_process(true)


func _physics_process(_delta):
	if !nav_agent.is_target_reachable():
		G.logs.create_log("inGame.logs.path_unreachable")
		stop.emit()
		set_physics_process(false)
		return
	
	if nav_agent.is_navigation_finished():
		stop.emit()
		set_physics_process(false)
		return
	
	var current_pos: Vector2 = parent.global_position
	var next_pos: Vector2 = nav_agent.get_next_path_position()
	
	parent.velocity = current_pos.direction_to(next_pos) * movement_speed
	parent.move_and_slide()
