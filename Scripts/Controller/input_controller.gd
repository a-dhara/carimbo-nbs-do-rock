extends Node
class_name InputController

signal move_event(point: Vector2)
signal press_event(button: bool)
signal quit_event()
signal mouse_motion(point: Vector2)

var _hor: Repeater = Repeater.new("move_left", "move_right")
var _ver: Repeater = Repeater.new("move_up", "move_down")
const buttons = ["select", "cancel"]

var _last_mouse: Vector2

func _process(_delta: float) -> void:
	# Movimentação
	var x = _hor.Update()
	var y = _ver.Update()
	if x != 0 ||  y != 0:
		move_event.emit(Vector2i(x,y))
	
	# Botões
	if Input.is_action_just_pressed(buttons[0]):
		press_event.emit(true)
	
	if Input.is_action_just_pressed(buttons[1]):
		press_event.emit(false)
	
	# Sair
	if Input.is_action_just_pressed("quit"):
		quit_event.emit()
	
	# Movimento do mouse
	var curr_mouse: Vector2 = get_viewport().get_mouse_position()
	var mouse_offset: Vector2 = Vector2(-16,-16)
	if _last_mouse != curr_mouse:
		_last_mouse = curr_mouse
		mouse_motion.emit(curr_mouse + mouse_offset)
	
