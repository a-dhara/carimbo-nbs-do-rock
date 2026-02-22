extends Node
class_name ConversationController

signal dialogue_finished
signal resume

@export var panel: ConversationPanel
@export var rect: TextureRect

var in_transition: bool = false

func _ready() -> void:
	panel.Hide(false)
	_DisableNode(panel)
	_DisableNode(rect)
	

func _DisableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func _EnableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()


func ShowDialogue(data: DialogueData) -> void:
	_EnableNode(panel)
	_EnableNode(rect)
	rect.show()
	await Sequence(data)

func Next() -> void:
	if not in_transition:
		resume.emit()
	

func Sequence(data: DialogueData) -> void:
	for sp_d in data.sequence:
		in_transition = true
		await panel.Show(true)
		in_transition = false
		await panel.Display(sp_d)
		
	in_transition = true
	await panel.Hide(true)
	in_transition = false
	_DisableNode(panel)
	_DisableNode(rect)
	dialogue_finished.emit()
