extends Control

@onready var icon: TextureRect = get_node("icon")
var default_color: Color

@export var my_state_name: String
@export var my_state_icon: Texture2D
@export var default_state_name = "walk"
@export var player_spawner: PlayerSpawner

var player_cotroller: MovementController


func _ready() -> void:
	if my_state_icon:
		icon.texture = my_state_icon
	default_color = icon.modulate
	player_spawner.player_loaded.connect(_on_player_loaded)


func _on_player_loaded(player: CharacterBody2D) -> void:
	player_cotroller = player.get_node("movementController")
	player_cotroller.state_changed.connect(check_player_state)


func _on_mouse_entered() -> void:
	icon.modulate = Color.YELLOW


func _on_mouse_exited() -> void:
	check_player_state(player_cotroller.current_state.name)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if player_cotroller.current_state.name != my_state_name:
			player_cotroller.load_state(my_state_name)
		else:
			player_cotroller.load_state(default_state_name)


func check_player_state(state: String) -> void:
	icon.modulate = Color.WHITE if state == my_state_name else default_color
