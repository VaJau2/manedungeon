extends VBoxContainer

@export var logPrefab: PackedScene


func _ready() -> void:
	var logItem = logPrefab.instantiate()
	add_child(logItem)
