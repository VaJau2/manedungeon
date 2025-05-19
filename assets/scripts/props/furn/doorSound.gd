extends AudioStreamPlayer2D


@export var open_sound: AudioStream
@export var close_sound: AudioStream


func _ready() -> void:
	var door = get_parent()
	door.opening.connect(_on_door_opening)
	door.closing.connect(_on_door_closing)


func _on_door_opening() -> void:
	stream = open_sound
	play()


func _on_door_closing() -> void:
	stream = close_sound
	play()
