extends Node2D
class_name Personagem

#region Referências
@export var sprite: AnimatedSprite2D
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
var tex_carimbos: Array[Texture2D] = [preload("res://Textures/Icons/barra_de_carimbada0.png"),
preload("res://Textures/Icons/barra_de_carimbada1.png"),
preload("res://Textures/Icons/barra_de_carimbada2.png"),
preload("res://Textures/Icons/barra_de_carimbada3.png")]
var tex_tintas: Array[Texture2D] = [preload("res://Textures/Icons/tinta-normal-phdr.png"), preload("res://Textures/Icons/tinta-cheia-phdr.png")]
#endregion

#region Atributos do Personagem
@export var inimigo: bool = false
@export var dist_max: int = 4 # Distância máxima de movimento do personagem
var dist: int = 4: # Distância de movimento, alterada pelo efeito de lentidão
	get():
		if lento > 0:
			return int(dist_max / 2.0)
		return dist_max
@export var veloc_max: float = 4.0 # Velocidade máxima de movimento do personagem, m/s
var veloc_mov: float = 4.0: # velocidade de movimento, afetada pela lentidão
	get():
		if lento > 0:
			return veloc_max / 2.0
		return veloc_max
#endregion

#region Variáveis do personagem
@export var lento: int = 0:
	set(value):
		if value > 0: default_anim = "pos_bomba"
		lento = value
@export var atordoado: int = 0:
	set(value):
		if value > 0: default_anim = "atordoado"
		atordoado = value
@export var carimbadas: int = 0:
	set(value):
		carimbadas = value
		carimbos_sprite.texture = tex_carimbos[value]
		if carimbadas == 2:
			default_anim = "2_carimb"
		if carimbadas == 3:
			sprite.animation = "3_carimb"
			await sprite.animation_finished
			default_anim = "caido"
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
var tiles_caminho: PackedVector2Array = []

var default_anim: String = "default":
	set(value):
		default_anim = value
		sprite.animation = value

#endregion

#region Funções de ajuste
## Coloca o personagem numa posição específica
func Place(alvo: Vector2i) -> void:
	if pos_grid != null and grid.conteudo.has(pos_grid) and grid.conteudo[pos_grid] == self:
		grid.conteudo.erase(pos_grid) # Tira a referência de si na posição antiga
	
	pos_grid = alvo # Posição nova
	
	if alvo != null: # Se não tiver ido embora
		grid.conteudo[pos_grid] = self # Coloca a referência de si na posição nova

## Ajeita a posição do personagem pro centro da célula em que ele estiver
func Ajeita() -> void:
	position = grid.calcula_pos_mapa(pos_grid)
#endregion

func Caminhar(final: Vector2i) -> void:
	sprite.animation = "andando"
	Place(final)
	for t in tiles_caminho:
		var dir: Vector2i = Vector2i(t) - pos_grid
		if dir.x < 0:
			sprite.flip_h = true
		if dir.x > 0:
			sprite.flip_h = false
		var tween: Tween = create_tween()
		tween.tween_property(
			self, "position", grid.calcula_pos_mapa(Vector2i(t)), 1.0/veloc_mov
		).set_trans(Tween.TRANS_CUBIC)
		
		await tween.finished
	sprite.animation = "default"



func _ready() -> void:
	turno = Turn.new(self)
	add_child(turno)
	turno.Reinicia()
	Place(grid.calcula_coord_grid(global_position))
	Ajeita()
	if carimbo.tipo == carimbo.Tipos.AUTOMATICO: carimbo_carr = true
