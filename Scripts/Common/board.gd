extends Node2D
class_name Board

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

#region Referências
@export var grid: Grid
@export var tile_map: TileMapLayer
@export var cell_overlay: TileMapLayer
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
	marker = Sprite2D.new()
	marker.texture = tile_selection_texture
	add_child(marker)
	
	pos = Vector2i(0,0)
	_old_pos = pos
	
	cell_overlay.modulate = Color(0.0, 0.0, 1.0, 0.325)


func GetTileContent(p: Vector2i) -> Node:
	return conteudo[p] if conteudo.has(p) else null


#region FloodFill e busca de células caminháveis

func _FloodFill(cell: Vector2i, dist_max: int) -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	var stack: Array[Vector2i] = [cell]
	
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
		for dir in DIRECTIONS:
			var coords: Vector2i = curr + dir
			if GetTileContent(coords) != null:
				continue
			if coords in array:
				continue
			if coords in stack:
				continue
			stack.append(coords)
	
	return array

func GetWalkableCells(pers: Personagem) -> Array[Vector2i]:
	return _FloodFill(pers.pos_grid, pers.dist)

#endregion


func SelectTiles(tile_list: Array[Vector2i]) -> void:
	for t in tile_list:
		cell_overlay.set_cell(t, 0, Vector2i(0,0))

func DeSelectTiles(_tile_list: Array[Vector2i]) -> void:
	cell_overlay.clear()
