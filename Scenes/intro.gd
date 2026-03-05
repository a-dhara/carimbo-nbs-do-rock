extends CombatController


func _ready() -> void:
	dialogue_state.data = load("res://Data/Dialogues/inicial_dialogue.tres")
	state_machine.ChangeState(dialogue_state)
