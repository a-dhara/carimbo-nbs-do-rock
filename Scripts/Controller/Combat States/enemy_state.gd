extends CombatState

@export var roundup_state: State

var _random: RandomNumberGenerator = RandomNumberGenerator.new()

func Enter() -> void:
	super()
	_random.randomize()
	
	for en in enemies:
		await Act(en)
	
	_owner.state_machine.ChangeState(roundup_state)


func Act(en: Personagem) -> void:
	# Tenta carimbar primeiro
	var possible_attacks: Array[Vector2i] = _owner.board.GetAttackableCells(en)
	if en.carimbo_carr and possible_attacks.size() != 0:
		Carimba(_owner.board.GetTileContent(possible_attacks.pick_random()), en)
		en.turno.ja_agiu = true
		print("carimbou de primeira")
	# Se não der carrega
	if not en.carimbo_carr and not en.turno.ja_agiu:
		Carrega(en)
		en.turno.ja_agiu = true
		print("escolheu carregar")
	# Aí anda
	var poss_cells: Array[Vector2i] = _owner.board.GetWalkableCells(en)
	if en.carimbo_carr:
		var num: int = _random.randi_range(0,10)
		if num > 3:
			# Verifica qual inimigo está mais perto
			var alvo: Personagem = characters.pick_random()
			var tile_alvo: Vector2i
			var min_dist: float = _owner.board.grid.tamanho.y
			# Verifica qual célula deixa mais próximo do inimigo alvo
			for tile in poss_cells:
				var dvec: Vector2i = alvo.pos_grid - tile
				var dist: float = sqrt(dvec.x^2 + dvec.y^2)
				if dist < min_dist:
					min_dist = dist
					tile_alvo = tile
			print("indo até o inimigo")
			await Move(en, tile_alvo, poss_cells)
		else:
			print("ficando parado")
			await get_tree().create_timer(1.0).timeout
	else:
		var num: int = _random.randi_range(0,10)
		if num > 3:
			print("voltando pra trás")
			Move(en, poss_cells.max(), poss_cells) # Foge pra trás
		else:
			print("ficando parado")
			await get_tree().create_timer(1.0).timeout
	en.turno.ja_moveu = true
	# Se ainda não tiver agido, tente novamente
	if not en.turno.ja_agiu:
		possible_attacks = _owner.board.GetAttackableCells(en)
		if en.carimbo_carr and possible_attacks.size() != 0:
			Carimba(_owner.board.GetTileContent(possible_attacks.pick_random()), en)
			en.turno.ja_agiu = true
			print("carimbando na segunda")
		if not en.carimbo_carr and not en.turno.ja_agiu:
			Carrega(en)
			en.turno.ja_agiu = true
			print("carregando na segunda")
	print("Final do turno")


func Carimba(p: Personagem, en: Personagem) -> void:
	p.carimbadas += 1
	en.carimbo_carr = false
	#en.turno.ja_agiu = true

func Carrega(en: Personagem) -> void:
	en.carimbo_carr = true
	#en.turno.ja_agiu = true

func Move(en: Personagem, tile: Vector2i, walk_ts: Array[Vector2i]) -> void:
	var _path_finder: PathFinder = PathFinder.new(_owner.board.grid, walk_ts)
	var caminho: PackedVector2Array = _path_finder.CalculaPontosCaminho(en.pos_grid, tile)
	
	en.tiles_caminho = caminho
	await en.Caminhar(tile)
