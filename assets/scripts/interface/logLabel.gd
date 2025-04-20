extends Label

var expireTimer = 2.0


func init_text(textCode: String) -> void:
	text = Loc.trans(textCode)


func _process(delta: float) -> void:
	if expireTimer > 0:
		expireTimer -= delta
	else:
		if modulate.a > 0:
			modulate.a -= delta
		else:
			queue_free()
