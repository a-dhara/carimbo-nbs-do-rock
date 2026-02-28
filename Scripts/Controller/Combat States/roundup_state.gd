extends CombatState

@export var select_unit_state: State

func Enter() -> void:
	super()
	for p in characters:
		p.turno.Reinicia()
	for e in enemies:
		e.turno.Reinicia()
	
	
	_owner.state_machine.ChangeState(select_unit_state)
