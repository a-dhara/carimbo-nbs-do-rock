extends CombatState

@export var select_unit_state: State

@export var mini_game_marmota: PackedScene

var mg: Node2D

func Enter() -> void:
	super()
	mg = mini_game_marmota.instantiate()
	mg.mini_game_ended.connect(OnMinigameEnded)
	_owner.add_child(mg)


func OnMinigameEnded() -> void:
	if mg.pont >= 5:
		_owner.curr_enemy.carimbadas += 1
	
	_owner.state_machine.ChangeState(select_unit_state)
	
