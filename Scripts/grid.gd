extends Resource
class_name Grid

@export var tamanho: Vector2i = Vector2i(20, 10) #tamanho do grid em número de células
@export var tam_cell: Vector2i = Vector2i(32, 32) #tamanho das células em pixels

var _metade_tam_cell: Vector2i = tam_cell / 2 #metade do tamanho de uma célula (usado pra centralizar)

var conteudo: Dictionary = {}

# Retorna a posição em coordenadas de mapa de uma dada posição no grid
func calcula_pos_mapa(pos_grid: Vector2i) -> Vector2:
	return pos_grid * tam_cell + _metade_tam_cell

# Retorna a posição em coordenadas de grid de uma dada posição no mapa
func calcula_coord_grid(pos_mapa: Vector2i) -> Vector2i:
	return pos_mapa / tam_cell

# Retorna true se a célula mencionada está dentro do grid
func verifica_limites(coord_cell: Vector2i) -> bool:
	var out: bool = coord_cell.x >= 0 and coord_cell.x < tamanho.x
	return out and (coord_cell.y >= 0 and coord_cell.y < tamanho.y)

# Faz com que a posição do grid dada esteja dentro dos limites do grid
func clamp_grid(grid_pos: Vector2i) -> Vector2i:
	var out:= grid_pos
	out.x = clamp(out.x, 0, tamanho.x - 1.0)
	out.y = clamp(out.y, 0, tamanho.y - 1.0)
	return out
