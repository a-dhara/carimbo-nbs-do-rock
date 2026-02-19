extends CombatState

@export var move_sequence_state: State
@export var action_selection_state: State

var tiles: Array[Vector2i] = []
var _path_finder: PathFinder
var caminho_atual: PackedVector2Array = []

func Enter() -> void:
	super()
	tiles = _owner.board.GetWalkableCells(current_char)
	_path_finder = PathFinder.new(_owner.board.grid, tiles)
	_owner.board.SelectTiles(tiles)

func Exit() -> void:
	super()
	current_char.tiles_caminho = caminho_atual
	caminho_atual = []
	_path_finder = null
	tiles = []
	_owner.board.DeSelectTiles(tiles) # no mometno o argumento não serve pra nada, testes

func OnMove(_e: Vector2i) -> void:
	SelectTile(_owner.board.pos + _e)
	caminho_atual = _path_finder.CalculaPontosCaminho(current_char.pos_grid, _owner.current_tile)

func OnPress(_e: bool) -> void:
	if _e:
		if tiles.has(_owner.current_tile):
			
			_owner.state_machine.ChangeState(move_sequence_state)
	else:
		_owner.state_machine.ChangeState(action_selection_state)

func OnMouseMotion(_e: Vector2) -> void:
	SelectTile(_owner.board.grid.calcula_coord_grid(_e))
	caminho_atual = _path_finder.CalculaPontosCaminho(current_char.pos_grid, _owner.current_tile)
