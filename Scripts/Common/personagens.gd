extends Node2D


func Play() -> void:
	var tween: = create_tween()
	tween.tween_property(
		self, "position", Vector2.ZERO, 2.0
	).set_trans(Tween.TRANS_LINEAR)
	await tween.finished
