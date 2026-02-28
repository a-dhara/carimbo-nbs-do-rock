extends Resource
class_name Carimbo

enum Tipos {
	NORMAL,
	FOFO,
	DISTANCIA,
	AUTOMATICO,
	BOMBA
}

@export var tipo: Tipos = Tipos.NORMAL

const dano: int = 1

## Distância de ataque do carimbo. Só é diferente de 1 para o carimbo à distância e pra bomba
var dist: int:
	get():
		if tipo == Tipos.DISTANCIA or tipo == Tipos.BOMBA:
			return 3
		return 1

## Área de ataque do carimbo. Só é diferente de 0 para a bomba de tinta
var area: int:
	get():
		if tipo == Tipos.BOMBA:
			return 2
		return 0

## Se o carimbo está ou não carregado
@export var carregado: bool:
	set(value):
		if tipo == Tipos.AUTOMATICO:
			carregado = true
		if tipo == Tipos.BOMBA: #é preciso carregar a bomba por um tempo
			prepara_bomba += 1
			if prepara_bomba == 3: #se já tiver carregado o suficiente
				prepara_bomba = 0
				carregado = true #considera como carregado
		else:
			carregado = value

var prepara_bomba: int = 0

var _texs: Array[Texture2D] = [load("res://Textures/Carimbos/carimbo-normal.png"),
load("res://Textures/Carimbos/carimbo-fofo.png"), load("res://Textures/Carimbos/carimbo-distancia.png"),
load("res://Textures/Carimbos/carimbo-automatico.png"), load("res://Textures/Carimbos/carimbo-bomba.png")]

var tex: Texture2D:
	get():
		return _texs[tipo]

var _descs: Array[String] = ["Carimbo comum! Dê carimbadas!",
"Fofinho! Atordoa os inimigos.", "Carimbo longo. Ataque à distância! 3 metros!", "Não precisa ser carregado!",
"Arremesse em alguém e atinja também quem estiver por perto! Área fica suja"]

var desc: String:
	get():
		return _descs[tipo]

var _nomes: Array[String] = ["normal", "fofo", "distância", "automático", "bomba"]

var nome: String:
	get():
		return _nomes[tipo]

func Attack(en: Personagem) -> void:
	match tipo:
		Tipos.NORMAL, Tipos.DISTANCIA, Tipos.AUTOMATICO:
			en.carimbadas += 1
		Tipos.FOFO:
			Fofo(en)
		Tipos.BOMBA:
			pass
	carregado = false




func Fofo(en: Personagem) -> void:
	en.carimbadas +=1
	en.atordoado = 1
