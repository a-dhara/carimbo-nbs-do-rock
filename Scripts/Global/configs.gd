extends Node

signal volume_changed(value)
signal control_changed(value)

const CONTROLES = ["Mouse e Teclado", "Só Teclado", "Controle"]

var volume: int = 20:
	set(val):
		val = clamp(val, 0, 20)
		volume_changed.emit(val)
		volume = val
var controle: String = "Mouse e Teclado":
	set(val):
		control_changed.emit(val)
		controle = val
var controle_ind: int = 0:
	set(val):
		val = clamp(val, 0, 2)
		controle = CONTROLES[val]
		controle_ind = val

func _ready() -> void:
	volume = 15
