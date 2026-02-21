extends Node
class_name CombatController

@export var board: Board
@export var input_controller: InputController
@export var conversation_controller: Node
@export var action_menu_controller: ActionMenuController
@export var state_machine: StateMachine
@export var start_state: State

@export var pers_prefab: PackedScene

var current_tile: Vector2i:
	get: return board.pos
var current_char: Personagem:
	set(value):
		if current_char:
			current_char.selected = false
		current_char = value
		if current_char:
			current_char.selected = true

var curr_enemy: Personagem

func _ready() -> void:
	state_machine.ChangeState(start_state)
