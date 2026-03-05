extends CombatState

signal fim_de_jogo()

@export var select_unit_state: State

var data: DialogueData

var fim: bool = false
var vitoria: bool = true

func Enter() -> void:
	super()
	_owner.conversation_controller.ShowDialogue(data)

func AddSignals() -> void:
	super()
	_owner.conversation_controller.dialogue_finished.connect(OnCompleteDialogue)

func RemoveSignals() -> void:
	super()
	_owner.conversation_controller.dialogue_finished.disconnect(OnCompleteDialogue)

func OnPress(_e: bool) -> void:
	super(_e)
	if _e:
		_owner.conversation_controller.Next()


func OnCompleteDialogue() -> void:
	if fim:
		if vitoria:
			fim_de_jogo.emit()
			_owner.state_machine.ChangeState(null)
			return
		else:
			fim_de_jogo.emit()
			_owner.state_machine.ChangeState(null)
			return
	_owner.state_machine.ChangeState(select_unit_state)
