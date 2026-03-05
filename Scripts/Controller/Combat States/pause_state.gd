extends CombatState

@export var panel: Control
@export var pause_controller: PauseMenuController


func Enter() -> void:
	super()
	pause_controller.EnterPause()
	pause_controller.quitted.connect(Exit)

func OnMove(_e: Vector2i) -> void:
	if _e.y > 0:
		pause_controller.Next()
	elif _e.y < 0:
		pause_controller.Previous()
	pause_controller.SideMov(_e.x)

func OnPress(_e: bool) -> void:
	if _e:
		pause_controller.Select()

func OnQuit() -> void:
	pass

func Exit() -> void:
	super()
	pause_controller.quitted.disconnect(Exit)
	_owner.state_machine._curr_state.process_mode = Node.PROCESS_MODE_INHERIT
	_owner.state_machine._curr_state.AddSignals()
