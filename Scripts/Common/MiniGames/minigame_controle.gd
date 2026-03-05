extends Node2D

signal mini_game_ended
signal move_event(e: Vector2i)
signal press_event()

@export var marmota_prefab: PackedScene
@export var parent_marmotas: Node2D
@export var label: Label
@export var label_pont: Label
@export var label_tempo: Label
@export var label_final: Label
@export var carimbo: Sprite2D
@export var timer: Timer
@export var markers: Array[Marker2D]
@export var marker: Sprite2D

var _marmotas: Array[MarmotaTeclado] = []
var pont: int = 0
var tempo_max: float = 10.0
var selection: int = 0
var offset: Vector2 = Vector2(0,-20)
var _started: bool = false
var base: String = "mg_"

var _hor: Repeater = Repeater.new("move_left", "move_right")
var _ver: Repeater = Repeater.new("move_up", "move_down")
var _grid_p: Vector2i

func _ready() -> void:
	for m in markers:
		var marmota: MarmotaTeclado = marmota_prefab.instantiate()
		marmota.process_mode = Node.PROCESS_MODE_DISABLED
		marmota.init_pos = m.position
		marmota.position = m.position
		_marmotas.append(marmota)
		marmota.apanhado.connect(OnMarmotaApanhou)
		parent_marmotas.add_child(marmota)
	marker.position = markers[0].position + offset
	_grid_p = Vector2i.ZERO
	move_event.connect(OnMove)
	press_event.connect(OnPress)
	for i in range(2,-1,-1):
		await get_tree().create_timer(1).timeout
		label.text = str(i)
	label.hide()
	_started = true
	for m in _marmotas:
		m.process_mode = Node.PROCESS_MODE_INHERIT
	
	timer.wait_time = tempo_max
	timer.start()

func _process(_delta: float) -> void:
	label_tempo.text = "tempo restante: " + str("%0.2f" %timer.time_left) + " s"
	var x = _hor.Update()
	var y = _ver.Update()
	if x != 0 ||  y != 0:
		move_event.emit(Vector2i(x,y))
	if _started:
		if Input.is_action_just_pressed("select"):
			press_event.emit()

func OnMove(e: Vector2i) -> void:
	_grid_p = _grid_p + e
	_grid_p.x = clamp(_grid_p.x, 0, 2)
	_grid_p.y = clamp(_grid_p.y, 0, 2)
	selection = _grid_p.x + _grid_p.y * 3
	marker.position = markers[selection].position + offset

func OnPress() -> void:
	_marmotas[selection].TentaApanha()




func OnMarmotaApanhou() -> void:
	pont += 1
	label_pont.text = "score: " + str(pont)
	carimbo.position = marker.position
	carimbo.show()
	await get_tree().create_timer(0.3).timeout
	carimbo.hide()


func _on_timer_timeout() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	label_final.text = label_final.text + str(pont)
	label_final.show()
	await get_tree().create_timer(2).timeout
	mini_game_ended.emit()
	hide()
