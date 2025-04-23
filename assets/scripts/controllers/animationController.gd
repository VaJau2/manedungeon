extends Node

@export var sprite: Sprite2D
@export var anim: AnimationPlayer
@export var movement_controller: MovementController
@onready var parent: CharacterBody2D = get_parent()

var watch_velocity: bool = false


func _ready() -> void:
	movement_controller.move.connect(on_mode)
	movement_controller.stop.connect(on_stop)


func on_stop() -> void:
	anim.play("idle")
	watch_velocity = false


func on_mode() -> void:
	anim.play("walk")
	watch_velocity = true


func _process(_delta) -> void:
	if watch_velocity:
		sprite.flip_h = parent.velocity.x < 0
