extends CombatState

@export var select_unit_state: State

var data_test: DialogueData

func Enter() -> void:
	super()
	data_test = load("res://Data/Dialogues/dialogue_test_1.tres")
	_owner.conversation_controller.ShowDialogue(data_test)

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
	_owner.state_machine.ChangeState(select_unit_state)
