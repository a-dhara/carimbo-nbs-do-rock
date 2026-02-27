extends Control
class_name InfoMenuPanel

var _pos_left: Vector2 = Vector2(5.0, 81.0)
var _pos_right: Vector2 = Vector2(303.0, 81.0)

func Show(pos: String) -> void:
	if pos == "Right":
		position = _pos_right
	if pos == "Left":
		position = _pos_left
	
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2
	).set_trans(Tween.TRANS_LINEAR)
	await tween.finished

func Hide() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2
	).set_trans(Tween.TRANS_LINEAR)
	await tween.finished	
