extends CombatState

@export var dialogue_state: State
@export var tst_ps: Array[Personagem]

func Enter() -> void:
	super()
	Init()



func Init() -> void:
	if _owner.fase == 0:
		dialogue_state.data = load("res://Data/Dialogues/inicial_dialogue.tres")
	else:
		dialogue_state.data = load("res://Data/Dialogues/fase1_inic.tres")
	_owner.state_machine.ChangeState(dialogue_state)
