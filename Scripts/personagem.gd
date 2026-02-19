extends Node2D
class_name Personagem

#region Referências
@export var sprite: Sprite2D
@export var selected_sprite: Sprite2D
@export var tinta_sprite: Sprite2D
@export var carr_tinta_label: Label
@export var carimbos_sprite: Sprite2D
@export var animation_player: AnimationPlayer
@export var grid: Grid
@export var carimbo: Carimbo # Carimbo que personagem está usando
@export var turno: Turn
#endregion

#region Textures
var tex_carimbos: Array[Texture2D] = [preload("res://Textures/barra_de_carimbada0.png"),
preload("res://Textures/barra_de_carimbada1.png"),
preload("res://Textures/barra_de_carimbada2.png"),
preload("res://Textures/barra_de_carimbada3.png")]
var tex_tintas: Array[Texture2D] = [preload("res://Textures/tinta-normal-phdr.png"), preload("res://Textures/tinta-cheia-phdr.png")]
#endregion

#region Atributos do Personagem
@export var inimigo: bool = false
@export var dist_max: int = 4 # Distância máxima de movimento do personagem
var dist: int = 4: # Distância de movimento, alterada pelo efeito de lentidão
	get():
		if lento > 0:
			return int(dist_max / 2.0)
		return dist_max
@export var veloc_max: float = 600.0 # Velocidade máxima de movimento do personagem, p/s
var veloc_mov: float = 600.0: # velocidade de movimento, afetada pela lentidão
	get():
		if lento > 0:
			return veloc_max / 2.0
		return veloc_max
#endregion

#region Variáveis do personagem
@export var lento: int = 0
@export var atordoado: int = 0
@export var carimbadas: int = 0:
	set(value):
		carimbadas = value
		carimbos_sprite.texture = tex_carimbos[value + 1]
var selected: bool = false:
	set(value):
		selected = value
		selected_sprite.visible = selected
		if not carimbo_carr: carr_tinta_label.visible = selected

## Se o carimbo está ou não carregado, retorna/atualiza o valor que está dentro da variável carimbo
var carimbo_carr: bool:
	set(value):
		carimbo.carregado = value
		if value:
			tinta_sprite.texture = tex_tintas[1]
			carr_tinta_label.visible = false
		else:
			tinta_sprite.texture = tex_tintas[0]
	get():
		return carimbo.carregado
var pos_grid: Vector2i # Posição no grid
#endregion

#region Funções de ajuste
## Coloca o personagem numa posição específica
func Place(alvo: Vector2i) -> void:
	if pos_grid != null and grid.conteudo.has(pos_grid) and grid.conteudo[pos_grid] == self:
		grid.conteudo.erase(pos_grid) # Tira a referência de si na posição antiga
	
	pos_grid = alvo # Posição nova
	
	if alvo != null: # Se não tiver ido embora
		grid.conteudo[pos_grid] = self # Coloca a referência de si na posição nova
	Ajeita()

## Ajeita a posição do personagem pro centro da célula em que ele estiver
func Ajeita() -> void:
	position = grid.calcula_pos_mapa(pos_grid)
#endregion

func _ready() -> void:
	turno = Turn.new(self)
	add_child(turno)
	turno.Reinicia()
