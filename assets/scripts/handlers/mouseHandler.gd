extends Node

class_name MouseHandler

#----------------------------------------------
# Отвечает за клики и драги мышкой
# Соединяется через другие ноды с помощью сигналов
#-----------------------------------------------
 
signal click(scenePos: Vector2)

@onready var main: Node2D = get_tree().get_first_node_in_group("main")



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && !event.pressed:
			click.emit(main.get_global_mouse_position())
