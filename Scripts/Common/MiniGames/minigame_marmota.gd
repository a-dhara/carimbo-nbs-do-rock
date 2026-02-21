extends Node2D

signal mini_game_ended

@export var marmota_prefab: PackedScene
@export var parent_marmotas: Node2D
@export var label: Label
@export var label_pont: Label
@export var label_tempo: Label
@export var label_final: Label
@export var carimbo: Sprite2D
@export var timer: Timer
@export var markers: Array[Marker2D]

var _marmotas: Array[Marmota] = []
var pont: int = 0
var tempo_max: float = 5
var pont_obj: int = 20

func _ready() -> void:
	for i in range(2,-1,-1):
		await get_tree().create_timer(1).timeout
		label.text = str(i)
	label.hide()
	
	for m in markers:
		var marmota: Marmota = marmota_prefab.instantiate()
		marmota.init_pos = m.position
		marmota.position = m.position
		_marmotas.append(marmota)
		marmota.apanhado.connect(OnMarmotaApanhou)
		parent_marmotas.add_child(marmota)
	
	timer.wait_time = tempo_max
	timer.start()

func _process(_delta: float) -> void:
	label_tempo.text = "tempo restante: " + str("%0.2f" %timer.time_left) + " s"


func OnMarmotaApanhou() -> void:
	pont += 1
	label_pont.text = "score: " + str(pont)
	carimbo.position = get_global_mouse_position()
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
