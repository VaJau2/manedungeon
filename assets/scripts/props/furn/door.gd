extends StaticBody2D

class_name Door

const CLOSE_TIME = 5

@export var anim: AnimationPlayer
@export var closed: bool = true

signal opening
signal closing

var light_occluder: LightOccluder2D
var close_timer: float = 0
var is_other_side: bool = false


func _ready() -> void:
	light_occluder = get_node("LightOccluder2D")
	set_process(false)


func reset_timer() -> void:
	close_timer = CLOSE_TIME


func set_open(open: bool, other_side: bool) -> void:
	closed = !open
	is_other_side = other_side
	anim.play(get_anim(open))
	light_occluder.visible = !open
	collision_layer = 0 if open else 1
	collision_mask = 0 if open else 1
	reset_timer()
	set_process(open)
	if open:
		opening.emit()
	else:
		closing.emit()



func get_anim(open: bool) -> String:
	if open:
		return "open-2" if is_other_side else "open"
	else:
		return "close-2" if is_other_side else "close"


func _process(delta: float) -> void:
	if close_timer > 0:
		close_timer -= delta
	else:
		set_open(false, is_other_side)
