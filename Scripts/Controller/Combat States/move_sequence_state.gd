extends CombatState

@export var select_unit_state: State

func Enter() -> void:
	super()
	Sequence()


func Sequence() -> void:
	await current_char.Caminhar(_owner.current_tile)
	current_char.turno.ja_moveu = true
	_owner.state_machine.ChangeState(select_unit_state)
