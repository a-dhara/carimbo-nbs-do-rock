extends Node
class_name State

func Enter() -> void:
	AddSignals()

func Exit() -> void:
	RemoveSignals()

func _exit_tree() -> void:
	RemoveSignals()

func AddSignals() -> void:
	pass

func RemoveSignals() -> void:
	pass
