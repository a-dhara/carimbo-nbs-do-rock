extends State
class_name CombatState

#region Referências
var _owner: CombatController
var action_menu_controller: ActionMenuController:
	get: return _owner.action_menu_controller
var current_char: Personagem:
	get: return _owner.current_char
	set(value): _owner.current_char = value
#var personagens: Array[Personagem]:
	#get: return _owner.personagens
#endregion

func _ready() -> void:
	_owner = get_parent().get_parent() # Combat States estão dentro da state machine que está dentro do combatcontroller

#region Conectando os sinais nas funções que lidarão com eles
## Conecta os sinais do input controller
func AddSignals() -> void:
	_owner.input_controller.move_event.connect(OnMove)
	_owner.input_controller.press_event.connect(OnPress)
	_owner.input_controller.quit_event.connect(OnQuit)
	_owner.input_controller.mouse_motion.connect(OnMouseMotion)

## Desconecta os sinais do input controller
func RemoveSignals() -> void:
	_owner.input_controller.move_event.disconnect(OnMove)
	_owner.input_controller.press_event.disconnect(OnPress)
	_owner.input_controller.quit_event.disconnect(OnQuit)
	_owner.input_controller.mouse_motion.disconnect(OnMouseMotion)
#endregion

# Seleciona um tile específico do grid
func SelectTile(p: Vector2i) -> void:
	if _owner.board.pos == p:
		return
	_owner.board.pos = _owner.board.grid.clamp_grid(p)
	pass


#region Funções que decidirão o que fazer com cada input a depender do combat state que estivermos
# Deve decidir o que fazer com o input de movimento
func OnMove(_e: Vector2i) -> void:
	pass

# Deve decidir o que fazer com o input de aceitar ou cancelar
func OnPress(_e: bool) -> void:
	pass

# Deve decidir o que fazer com o input de quit
func OnQuit() -> void:
	print("quit")
	get_tree().quit() # PROVISÓRIO, DEVE ABRIR O MENU AO INVÉS DE SÓ FECHAR TUDO

# Deve decidir o que fazer com o input de movimento do mouse
func OnMouseMotion(_e: Vector2) -> void:
	pass
#endregion
