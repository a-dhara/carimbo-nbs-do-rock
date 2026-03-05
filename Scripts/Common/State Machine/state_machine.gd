extends Node
class_name StateMachine

@export var pause_state: State

var _curr_state: State

func ChangeState(new_state: State) -> void:
	#if new_state == _curr_state:
		#return
	if _curr_state:
		@warning_ignore("redundant_await") # Ele dá um aviso desnecessário pq a gnt usa na herança
		await _curr_state.Exit()
	
	_curr_state = new_state
	if _curr_state:
		_curr_state.Enter()

func PauseState() -> void:
	_curr_state.process_mode = Node.PROCESS_MODE_DISABLED
	_curr_state.RemoveSignals()
	pause_state.Enter()
