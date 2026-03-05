extends CombatState



@export var action_selection_state: State
@export var enemy_state: State
@export var dialogue_state: State

func Enter() -> void:
	super()
	if characters.size() == 0:
		dialogue_state.fim = true
		dialogue_state.vitoria = false
		if _owner.fase == 0:
			dialogue_state.data = load("res://Data/Dialogues/fase0_fim_derrota_dialogue.tres")
		if _owner.fase == 1:
			dialogue_state.data = load("res://Data/Dialogues/final.tres")
			_owner.music.stream = load("res://Textures/Musicas/january_feeling.mp3")
			$"../../DialogueController/TextureRect2".show()
		_owner.state_machine.ChangeState(dialogue_state)
		return
	if enemies.size() == 0:
		dialogue_state.fim = true
		dialogue_state.vitoria = true
		if _owner.fase == 0:
			dialogue_state.data = load("res://Data/Dialogues/fase0_fim_vitoria_dialogue.tres")
		if _owner.fase == 1:
			dialogue_state.data = load("res://Data/Dialogues/final.tres")
			_owner.music.stream = load("res://Textures/Musicas/january_feeling.mp3")
			$"../../DialogueController/TextureRect2".show()
		_owner.state_machine.ChangeState(dialogue_state)
		return
	_owner.current_char = null
	var fim_turno: bool = true
	for p in characters:
		if (not p.turno.ja_agiu and ((not p.carimbo_carr) or _owner.board.GetAttackableCells(p).size() != 0)) or (not p.turno.ja_moveu):
			fim_turno = false
	if fim_turno:
		_owner.state_machine.ChangeState(enemy_state)

func OnMove(_e: Vector2i) -> void:
	SelectTile(_e + _owner.board.pos)

func OnMouseMotion(_e: Vector2) -> void:
	SelectTile(_owner.board.grid.calcula_coord_grid(_e))
	pass

func OnPress(_e: bool) -> void:
	if _e:
		if _owner.board.conteudo.has(_owner.board.pos):
			var obj = _owner.board.conteudo[_owner.board.pos]
			if obj is Personagem and not obj.inimigo: # Tá um pouquinho hard coded mas vambora
				if (not obj.turno.ja_agiu and ((not obj.carimbo_carr) or _owner.board.GetAttackableCells(obj).size() != 0)) or (not obj.turno.ja_moveu):
					if obj.carimbadas < 3:
						current_char = obj
						$"../../../Confirma".play()
						_owner.state_machine.ChangeState(action_selection_state)
		else:
			current_char = null
	else:
		current_char = null
