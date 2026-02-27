extends Node
class_name InfoMenuController

@export var input_controller: InputController

@export var panel: InfoMenuPanel
@export var label_nome_pers: Label
@export var label_nome_carimbo: Label
@export var tex_carimbo: TextureRect
@export var label_descr_carimbo: Label


var _str_base_car: String = "usa um carimbo do tipo "
var shown: bool = false

func _ready() -> void:
	panel.Hide()
	_DisableNode(panel)
	

func _DisableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func _EnableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()

func ShowMenu(pers: Personagem) -> void:
	shown = true
	_EnableNode(panel)
	label_nome_pers.text = pers.name
	label_nome_carimbo.text = _str_base_car + str(pers.carimbo.nome).to_lower()
	tex_carimbo.texture = pers.carimbo.tex
	label_descr_carimbo.text = pers.carimbo.desc
	
	panel.Show("Right")
	

func HideMenu() -> void:
	shown = false
	panel.Hide()
	_DisableNode(panel)
