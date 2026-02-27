extends Node
class_name CombatController

@export var board: Board
@export var input_controller: InputController
@export var conversation_controller: ConversationController
@export var action_menu_controller: ActionMenuController
@export var info_menu_controller: InfoMenuController
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

var characters: Array[Personagem] = []
var enemies: Array[Personagem] = []

func _ready() -> void:
	state_machine.ChangeState(start_state)
	for p in get_node("Personagens").get_children():
		if p.inimigo:
			enemies.append(p)
		else:
			characters.append(p)
