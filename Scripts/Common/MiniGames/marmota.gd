extends Area2D
class_name Marmota

var _offset: Vector2 = Vector2(0, -20)
var _random: RandomNumberGenerator = RandomNumberGenerator.new()
signal apanhado

var init_pos: Vector2

func _init() -> void:
	_random.randomize()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		if Rect2($ColShape.global_position - $ColShape.shape.size / 2, $ColShape.shape.size).has_point(get_global_mouse_position()) and not $ColShape.disabled:
			Apanha()
			apanhado.emit()
		


func Sobe() -> void:
	$ColShape.disabled = false
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "position", init_pos + _offset, 0.5
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func Desce() -> void:
	$ColShape.disabled = true
	var tween: Tween = create_tween()
	tween.tween_property(
		self, "position", init_pos, 0.5
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished


func Apanha() -> void:
	modulate = Color(0.187, 0.187, 0.187, 1.0)
	$Timer.stop()
	await Desce()
	$Timer.start()
	modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_timer_timeout() -> void:
	var out: int = _random.randi_range(0,10)
	if out >= 7 and $ColShape.disabled:
		Sobe()
	else:
		Desce()
