extends CombatState

@export var dialogue_state: State
@export var tst_ps: Array[Personagem]

func Enter() -> void:
	super()
	Init()


func Init() -> void:
	# carrega o mapa (?)
	InitTest()
	
	_owner.state_machine.ChangeState(dialogue_state)

func SpawnTestUnits() -> void:
	for i in 4:
		var pers: Personagem = _owner.pers_prefab.instantiate()
		pers.carimbo = Carimbo.new()
		if i == 0:
			pers.carimbo.tipo = pers.carimbo.Tipos.DISTANCIA
		_owner.add_child(pers)
		var p: Vector2i = Vector2i(0,2*i)
		if i == 0:
			pers.carimbo_carr = true
		if i == 1:
			pers.inimigo = true
			pers.sprite.modulate = Color(1.0, 0.336, 0.27, 1.0)
		if i == 3:
			p = Vector2i(1,2)
		pers.Place(p)
		pers.Ajeita()
	
	
	pass

func InitTest() -> void:
	for p in tst_ps:
		if p:
			if p.carimbo.tipo == p.carimbo.Tipos.BOMBA:
				p.carimbo.prepara_bomba = 2
			p.carimbo_carr = false
	
