extends Resource
class_name Carimbo

enum Tipos {
	NORMAL,
	FOFO,
	DIST,
	AUTOM,
	BOMBA
}

@export var tipo: Tipos = Tipos.NORMAL

const dano: int = 1

## Distância de ataque do carimbo. Só é diferente de 1 para o carimbo à distância e pra bomba
var dist: int:
	get():
		if tipo == Tipos.DIST:
			return 3
		if tipo == Tipos.BOMBA:
			return 3
		return 1

## Área de ataque do carimbo. Só é diferente de 0 para a bomba de tinta
var area: int:
	get():
		if tipo == Tipos.BOMBA:
			return 2
		return 0

## Se o carimbo está ou não carregado
var carregado: bool:
	set(value):
		if tipo == Tipos.AUTOM:
			carregado = true
		if tipo == Tipos.BOMBA: #é preciso carregar a bomba por um tempo
			prepara_bomba += 1
			if prepara_bomba == 3: #se já tiver carregado o suficiente
				prepara_bomba = 0
				carregado = true #considera como carregado
		else:
			carregado = value

var prepara_bomba: int = 0

func Ataque(inim: Personagem) -> void:
	inim.carimbadas += dano

func Explosao() -> void:
	pass

func Fofo() -> void:
	pass
