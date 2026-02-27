extends CombatState

@export var action_selection_state: State
@export var enemy_state: State

func Enter() -> void:
	super()
	_owner.current_char = null
	var fim_turno: bool = true
	for p in characters:
		if (not p.turno.ja_agiu and ((not p.carimbo_carr) or _owner.board.GetAttackableCells(p).size() != 0)) or (not p.turno.ja_moveu):
			fim_turno = false
	if fim_turno:
		_owner.state_machine.ChangeState(enemy_state)

func OnMove(_e: Vector2i) -> void:
	SelectTile(_e + _owner.board.pos)

func OnMouseMotion(_e: Vector2) -> void:
	SelectTile(_owner.board.grid.calcula_coord_grid(_e))
	pass

func OnPress(_e: bool) -> void:
	if _e:
		if _owner.board.conteudo.has(_owner.board.pos):
			var obj = _owner.board.conteudo[_owner.board.pos]
			if obj is Personagem and not obj.inimigo: # Tá um pouquinho hard coded mas vambora
				if (not obj.turno.ja_agiu and ((not obj.carimbo_carr) or _owner.board.GetAttackableCells(obj).size() != 0)) or (not obj.turno.ja_moveu):
					current_char = obj
					_owner.state_machine.ChangeState(action_selection_state)
		else:
			current_char = null
	else:
		current_char = null
