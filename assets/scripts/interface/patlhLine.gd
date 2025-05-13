extends Line2D

@onready var point: Sprite2D = get_node("point")
var player: Node2D
var start_distance: float


func _ready() -> void:
	start_distance = get_distance()


func _process(_delta: float) -> void:
	var opacity = get_distance() / start_distance
	gradient.set_color(1, Color(1, 1, 1, opacity))
	point.modulate.a = opacity


func get_distance() -> float:
	return point.global_position.distance_to(player.global_position)
