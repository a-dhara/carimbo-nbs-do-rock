extends Node2D
class_name Board

#region Referências
@export var grid: Grid
@export var tile_map: TileMapLayer
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

func GetTileContent(p: Vector2i) -> Node:
	return conteudo[p] if conteudo.has(p) else null


## Search de distâncias dados os tiles
#
#
#
#
#
#####

func SelectTiles(_tileList: Array[Vector2]) -> void:
	pass

func DeSelectTiles(_tileList: Array[Vector2]) -> void:
	pass
