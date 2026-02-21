extends CombatState

@export var move_selection_state: State
@export var attack_selection_state: State
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
	action_menu_controller.SetLocked(0, current_char.carimbo_carr or current_char.turno.ja_agiu)
	action_menu_controller.SetLocked(1, current_char.turno.ja_moveu)
	action_menu_controller.SetLocked(2, not _owner.board.GetAttackableCells(current_char).size() != 0 or current_char.turno.ja_agiu or not current_char.carimbo_carr)
	await action_menu_controller.Show(current_char.position)

func Cancel() -> void:
	_owner.state_machine.ChangeState(select_unit_state)

func Confirm() -> void:
	match action_menu_controller.selection:
		0:
			current_char.carimbo_carr = true
			current_char.turno.ja_agiu = true
			if current_char.turno.ja_moveu:
				_owner.state_machine.ChangeState(select_unit_state)
			else:
				_owner.state_machine.ChangeState(self)
		1:
			_owner.state_machine.ChangeState(move_selection_state)
		2:
			_owner.state_machine.ChangeState(attack_selection_state)
