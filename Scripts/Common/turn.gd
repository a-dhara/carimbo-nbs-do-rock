extends Node
class_name Turn

var _actor: Personagem

var ja_moveu: bool
var ja_agiu: bool
var trava_mov: bool

var pos_ini: Vector2i

func _init(actor: Personagem) -> void:
	_actor = actor

func Reinicia() -> void:
	ja_moveu = false
	ja_agiu = false
	trava_mov = false
	pos_ini = _actor.pos_grid

func DesfazMov() -> void:
	ja_moveu = false
	_actor.Place(pos_ini)
