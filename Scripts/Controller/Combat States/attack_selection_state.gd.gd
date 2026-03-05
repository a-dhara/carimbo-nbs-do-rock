extends CombatState

@export var action_selection_state: State
@export var select_unit_state: State
@export var mini_game_state: State


var tiles: Array[Vector2i] = []

func Enter() -> void:
	super()
	tiles = _owner.board.GetAttackableCells(current_char)
	_owner.board.SelectTiles(tiles, false)

func Exit() -> void:
	super()
	tiles = []
	_owner.board.DeSelectTiles(tiles) # no mometno o argumento não serve pra nada, testes

func OnMove(_e: Vector2i) -> void:
	SelectTile(_owner.board.pos + _e)

func OnPress(_e: bool) -> void:
	if _e:
		if tiles.has(_owner.current_tile) and _owner.board.conteudo[_owner.current_tile].carimbadas < 3:
			_owner.curr_enemy = _owner.board.conteudo[_owner.current_tile]
			current_char.turno.ja_agiu = true
			$"../../../Confirma".play()
			_owner.state_machine.ChangeState(mini_game_state)
			#if current_char.turno.ja_moveu:
				#_owner.state_machine.ChangeState(select_unit_state)
			#else:
				#_owner.state_machine.ChangeState(action_selection_state)
	else:
		_owner.state_machine.ChangeState(action_selection_state)
		$"../../../Cancela".play()

func OnMouseMotion(_e: Vector2) -> void:
	SelectTile(_owner.board.grid.calcula_coord_grid(_e))
