extends CombatState

@export var action_selection_state: State

@export var mini_game_marmota: PackedScene

var mg: Node2D

func Enter() -> void:
	super()
	mg = mini_game_marmota.instantiate()
	mg.mini_game_ended.connect(OnMinigameEnded)
	_owner.add_child(mg)
	_owner.get_node("Personagens").hide()


func OnMinigameEnded() -> void:
	if mg.pont >= 5:
		_owner.curr_enemy.carimbadas += 1
	
	_owner.get_node("Personagens").show()
	_owner.state_machine.ChangeState(action_selection_state)
	
