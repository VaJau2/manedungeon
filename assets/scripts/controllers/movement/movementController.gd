extends Node

class_name MovementController

#----------------------------------------------
# Отвечает за передвижение персонажа через навигацию
#-----------------------------------------------

@onready var parent: CharacterBody2D = get_parent()
@export var nav_agent: NavigationAgent2D
@export var movement_speed = 100
@export var print_logs = false

var current_state: MovementState

signal move
signal stop
signal state_changed(state: String)

var target: Vector2


func _ready() -> void:
	set_physics_process(false)
	load_state('default')


func _physics_process(_delta):
	if !nav_agent.is_target_reachable():
		if print_logs: G.logs.create_log("inGame.logs.path_unreachable")
		set_velocity(Vector2.ZERO)
		set_physics_process(false)
		return
	
	if nav_agent.is_navigation_finished():
		set_velocity(Vector2.ZERO)
		set_physics_process(false)
		return
	
	var current_pos: Vector2 = parent.global_position
	var next_pos: Vector2 = nav_agent.get_next_path_position()
	
	set_velocity(current_pos.direction_to(next_pos) * current_state.speed)


func load_state(state_name: String = 'default') -> void:
	if state_name == 'default':
		for state in get_children():
			if state is MovementState and state.default:
				set_current_state(state)
	else:
		set_current_state(get_node(state_name))


func load_next_state() -> void:
	var is_next: bool = false
	
	for state in get_children():
		if state == current_state:
			is_next = true
			continue
		if is_next:
			set_current_state(state)
			return
	
	var first_state = get_child(0)
	set_current_state(first_state)


func set_current_state(new_state: MovementState) -> void:
	current_state = new_state
	state_changed.emit(new_state.name)


func set_target(new_target: Vector2) -> void:
	nav_agent.target_position = new_target
	set_physics_process(true)


func set_velocity(new_velocity: Vector2) -> void:
	parent.velocity = new_velocity
	
	if new_velocity.length() > 0:
		move.emit()
		parent.move_and_slide()
	else:
		stop.emit()


func is_navigating() -> bool:
	return is_physics_processing()


func stop_navigation() -> void:
	set_physics_process(false)
	stop.emit()
