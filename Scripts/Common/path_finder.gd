extends Resource
class_name PathFinder

var _grid: Grid

var _astar: AStarGrid2D = AStarGrid2D.new()

func _init(grid: Grid, walkable_cells: Array) -> void:
	_grid = grid
	_astar.region.size = _grid.tamanho
	_astar.cell_size = _grid.tam_cell
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.update()
	for y in _grid.tamanho.y:
		for x in _grid.tamanho.x:
			if not walkable_cells.has(Vector2i(x,y)):
				_astar.set_point_solid(Vector2i(x,y))

func CalculaPontosCaminho(inicio: Vector2i, fim: Vector2i) -> PackedVector2Array:
	return _astar.get_id_path(inicio, fim)
