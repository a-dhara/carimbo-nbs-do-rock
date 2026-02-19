extends CombatState

@export var action_selection_state: State

func Enter() -> void:
	super()
	_owner.current_char = null

func OnMove(_e: Vector2i) -> void:
	SelectTile(_e + _owner.board.pos)

func OnMouseMotion(_e: Vector2) -> void:
	SelectTile(_owner.board.grid.calcula_coord_grid(_e))
	pass

func OnPress(_e: bool) -> void:
	if _e:
		if _owner.board.conteudo.has(_owner.board.pos):
			var obj = _owner.board.conteudo[_owner.board.pos]
			if obj is Personagem and not obj.inimigo:
				current_char = obj
				_owner.state_machine.ChangeState(action_selection_state)
		else:
			current_char = null
	else:
		current_char = null
