extends CombatState

@export var select_unit_state: State

func Enter() -> void:
	super()
	for p in characters:
		p.turno = Turn.new(p)
		if p.atordoado > 0:
			p.atordoado -= 1
		if p.lento > 0:
			p.lento -= 1
	for e in enemies:
		e.turno = Turn.new(e)
		if e.atordoado > 0:
			e.atordoado -= 1
		if e.lento > 0:
			e.lento -= 1
	
	
	_owner.state_machine.ChangeState(select_unit_state)
