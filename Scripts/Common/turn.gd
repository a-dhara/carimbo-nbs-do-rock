extends Node
class_name Turn

var _actor: Personagem

var ja_moveu: bool:
	set(value):
		_actor.sprite_moveu.visible = value
		ja_moveu = value
var ja_agiu: bool:
	set(value):
		_actor.sprite_agiu.visible = value
		ja_agiu = value
var trava_mov: bool

var pos_ini: Vector2i

func _init(actor: Personagem) -> void:
	_actor = actor
	Reinicia()

func Reinicia() -> void:
	ja_moveu = false
	ja_agiu = false
	trava_mov = false
	pos_ini = _actor.pos_grid
	if _actor.atordoado > 0:
		_actor.atordoado -= 1
		ja_moveu = true
		ja_agiu = true
		_actor.sprite.animation =  _actor.default_anim
	if _actor.lento > 0:
		_actor.lento -= 1
	if _actor.carimbadas == 3:
		ja_moveu = true
		ja_agiu = true
