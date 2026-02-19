extends CombatState

@export var move_selection_state: State
@export var select_unit_state: State

@export var menu_options: Array[Texture2D] = []


func Enter() -> void:
	super()
	SelectTile(current_char.pos_grid)
	await LoadMenu()


func Exit() -> void:
	super()
	await action_menu_controller.Hide()

func OnPress(_e: bool) -> void:
	if _e:
		Confirm()
	else:
		Cancel()

func OnMove(_e: Vector2i) -> void:
	if _e.y > 0:
		action_menu_controller.Next()
	else:
		action_menu_controller.Previous()

func OnMouseMotion(_e: Vector2) -> void:
	var ind: int = action_menu_controller.GetEntryByPosition(_e)
	if ind == -1 or ind == action_menu_controller.selection or ind >= action_menu_controller.menu_entries.size():
		return
	action_menu_controller.SetSelection(ind)

#

func LoadMenu() -> void:
	action_menu_controller.StartEntries(menu_options)
	action_menu_controller.SetLocked(0, current_char.carimbo_carr)
	action_menu_controller.SetLocked(1, current_char.turno.ja_moveu)
	action_menu_controller.SetLocked(2, not HaInimigosPerto(current_char.pos_grid))
	await action_menu_controller.Show(current_char.position)

func Cancel() -> void:
	_owner.state_machine.ChangeState(select_unit_state)

func Confirm() -> void:
	match action_menu_controller.selection:
		0:
			print("carregou!!!")
		1:
			print("andar!!")
			_owner.state_machine.ChangeState(move_selection_state)
		2:
			print("ataque!!")

func HaInimigosPerto(pos_grid: Vector2i) -> bool:
	var out: bool = false
	for d in _owner.board.DIRECTIONS:
		if _owner.board.conteudo.has(pos_grid + d):
			var obj = _owner.board.conteudo[pos_grid + d]
			if obj is Personagem and obj.inimigo:
				out = true
	return out
