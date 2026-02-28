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

func InitTest() -> void:
	pass
