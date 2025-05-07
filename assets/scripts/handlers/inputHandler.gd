extends Control

class_name InputHandler

#----------------------------------------------
# Отвечает за клики и драги мышкой
# И за кнопки клавиатуры
# Соединяется через другие ноды с помощью сигналов
#-----------------------------------------------
 
const MIN_MOUSE_RELATIVE: float = 1

signal click(scenePos: Vector2)
signal dragging(velocity: Vector2)
signal key_running
signal key_crouching
signal zoom_in
signal zoom_out

@onready var main: Node2D = get_node('/root/main')

var mouse_on: bool = false
var is_dragging: bool = false


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom_out.emit()
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in.emit()
			MOUSE_BUTTON_LEFT:
				mouse_on = event.pressed
				if !event.pressed:
					if is_dragging:
						is_dragging = false
						return
					click.emit(main.get_global_mouse_position())
	
	if event is InputEventMouseMotion && mouse_on:
		if event.relative.length() > MIN_MOUSE_RELATIVE or is_dragging:
			is_dragging = true
			dragging.emit(event.relative)


func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("ui_change_keys_moving"):
		change_keys_moving_value()
	
	if Input.is_action_just_pressed("ui_run"):
		key_running.emit()
	if Input.is_action_just_pressed("ui_crouch"):
		key_crouching.emit()


func get_dir() -> Vector2:
	var result = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		result.y -= 1
	if Input.is_action_pressed("ui_down"):
		result.y += 1
	if Input.is_action_pressed("ui_left"):
		result.x -= 1
	if Input.is_action_pressed("ui_right"):
		result.x += 1
	return result


func change_keys_moving_value() -> void:
	var old_value = G.settings.keys_moving
	if old_value == Enums.KeyMoving.player:
		G.settings.keys_moving = Enums.KeyMoving.camera
	else:
		G.settings.keys_moving = Enums.KeyMoving.player
	
	G.logs.create_log("inGame.logs.keys_moving." \
		+ ("player" if old_value == Enums.KeyMoving.camera else "camera"))
