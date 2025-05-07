extends Control

@onready var icon: TextureRect = get_node("icon")
var default_color: Color

@export var state_icons: Dictionary
@export var player: CharacterBody2D

var player_cotroller: MovementController


func _ready() -> void:
	default_color = icon.modulate
	player_cotroller = player.get_node("movementController")
	load_icon(player_cotroller.current_state.name)
	player_cotroller.state_changed.connect(load_icon)


func _on_mouse_entered() -> void:
	icon.modulate = Color.WHITE


func _on_mouse_exited() -> void:
	icon.modulate = default_color


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		player_cotroller.load_next_state()


func load_icon(state_name: String) -> void:
	icon.texture = state_icons[state_name]
