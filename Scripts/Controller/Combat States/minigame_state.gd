extends CombatState

@export var action_selection_state: State
@export var select_unit_state: State
@export var mini_game_mouse: PackedScene
@export var mini_game_teclado: PackedScene
@export var mini_game_controle: PackedScene

var mg: Node2D

func Enter() -> void:
	super()
	match Configs.controle:
		"Mouse e Teclado":
			mg = mini_game_mouse.instantiate()
		"Só Teclado":
			mg = mini_game_teclado.instantiate()
		"Controle":
			mg = mini_game_controle.instantiate()
	mg.mini_game_ended.connect(OnMinigameEnded)
	_owner.add_child(mg)
	_owner.get_node("Personagens").hide()


func OnMinigameEnded() -> void:
	if mg.pont >= 5:
		current_char.carimbo.Attack(current_en)
		if current_char.carimbo.tipo == current_char.carimbo.Tipos.BOMBA:
			Bomba()
		current_char.carimbo_carr = current_char.carimbo.carregado
		if current_en.carimbadas == 3:
			enemies.pop_at(enemies.find(current_en))
	
	_owner.get_node("Personagens").show()
	if (current_char.turno.ja_agiu or ((current_char.carimbo_carr) and _owner.board.GetAttackableCells(current_char).size() == 0)) and (current_char.turno.ja_moveu):
		_owner.state_machine.ChangeState(select_unit_state)
	else:
		_owner.state_machine.ChangeState(action_selection_state)
	

func Bomba() -> void:
	var ens: Array[Personagem] =_owner.board.BombCell(current_en.pos_grid, 1)
	for en in ens:
		en.carimbadas += 1
		en.sprite.animation = "bomba"
		await en.sprite.animation_finished
		en.lento = 1
