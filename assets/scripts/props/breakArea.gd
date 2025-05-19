extends Area2D

@export var anim: AnimationPlayer
@export var audi: AudioStreamPlayer2D
var breaking: bool


func _ready() -> void:
	anim.connect("animation_finished", _on_animation_finished)


func _on_body_entered(_body: Node2D) -> void:
	if breaking: return
	breaking = true
	anim.play("break")
	audi.play()


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "break":
		get_parent().queue_free()
