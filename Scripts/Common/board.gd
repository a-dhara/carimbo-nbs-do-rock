extends Node2D
class_name Board

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

#region Referências
@export var grid: Grid
@export var collision_map: TileMapLayer
@export var ink_map: TileMapLayer
@export var cell_overlay: TileMapLayer
@export var base: Sprite2D
#endregion

@export var tile_selection_texture: Texture2D
@export var pos: Vector2i: #automatically updates the marker's position
	set(value):
		marker.position = grid.calcula_pos_mapa(value)
		pos = value
var _old_pos: Vector2i
var marker: Sprite2D
var conteudo: Dictionary:
	get():
		return grid.conteudo


func _ready() -> void:
	for c in collision_map.get_used_cells():
		conteudo[c] = Node.new()
	
	marker = Sprite2D.new()
	marker.texture = tile_selection_texture
	add_child(marker)
	
	pos = Vector2i(0,0)
	_old_pos = pos
	


func GetTileContent(p: Vector2i) -> Node:
	return conteudo[p] if conteudo.has(p) else null


#region FloodFill e busca de células caminháveis

func _FloodFill(cell: Vector2i, dist_max: int, tipo: String) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	var stack: Array[Vector2i] = [cell]
	var out_a: Array[Vector2i] = []
	
	while not stack.size() == 0:
		var curr: Vector2i = stack.pop_back()
		
		if not grid.verifica_limites(curr):
			continue
		if curr in array:
			continue
		
		var diff: Vector2i = (curr - cell).abs()
		var dist: int = int(diff.x + diff.y)
		if dist > dist_max:
			continue
		
		array.append(curr)
		if tipo == "atk" and GetTileContent(curr) is Personagem:
			out_a.append(curr)
		for dir in DIRECTIONS:
			var coords: Vector2i = curr + dir
			if tipo == "wlk" and GetTileContent(coords) != null:
				continue
			if coords in array:
				continue
			if coords in stack:
				continue
			stack.append(coords)
	if tipo == "atk":
		return out_a
	return array

func GetWalkableCells(pers: Personagem) -> Array[Vector2i]:
	return _FloodFill(pers.pos_grid, pers.dist, "wlk")

func GetAttackableCells(pers: Personagem) -> Array[Vector2i]:
	var cells: Array[Vector2i] =_FloodFill(pers.pos_grid, pers.carimbo.dist, "atk")
	var out: Array[Vector2i] = []
	for c in cells:
		# Um aliado busca atacar inimigos e um inimigo busca atacar aliados
		if (not pers.inimigo and GetTileContent(c).inimigo) or (pers.inimigo and not GetTileContent(c).inimigo):
			if GetTileContent(c).carimbadas < 3:
				out.append(c)
	return out

func BombCell(bomb_pos: Vector2i, brange: int) -> Array[Personagem]:
	var cells: Array[Vector2i] = _FloodFill(bomb_pos, brange, "bmb")
	var out: Array[Personagem] = []
	for c in cells:
		ink_map.set_cell(c, 0, Vector2i(0,0))
		#if GetTileContent(p).inimigo:
		if GetTileContent(c) is Personagem:
			out.append(GetTileContent(c))
	return out

#endregion


func SelectTiles(tile_list: Array[Vector2i], w_or_a: bool) -> void:
	if w_or_a:
		cell_overlay.modulate = Color(0.0, 0.0, 1.0, 0.325)
	else:
		cell_overlay.modulate = Color(1.0, 0.0, 0.0, 0.325)
	for t in tile_list:
		cell_overlay.set_cell(t, 0, Vector2i(0,0))

func DeSelectTiles(_tile_list: Array[Vector2i]) -> void:
	cell_overlay.clear()
