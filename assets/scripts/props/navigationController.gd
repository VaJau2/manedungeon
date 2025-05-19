extends NavigationRegion2D


func _ready() -> void:
	for child in get_children():
		if child.has_signal("change_navigation"):
			child.change_navigation.connect(_on_change_navigation)


func _on_change_navigation() -> void:
	bake_navigation_polygon(true)
