extends Area2D

@onready var door: Door = get_parent()
@export var other_side: bool


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if door.closed:
			door.set_open(true, other_side)
		else:
			door.reset_timer()
