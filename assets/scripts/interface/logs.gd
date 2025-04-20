extends VBoxContainer

#----------------------------
# Создает логи внутри себя
#----------------------------


@export var logPrefab: PackedScene


func _ready() -> void:
	create_log("inGame.logs.start")


func create_log(text: String) -> void:
	var logItem = logPrefab.instantiate()
	logItem.init_text(text)
	add_child(logItem)
