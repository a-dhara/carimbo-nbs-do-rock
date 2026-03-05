extends Node
class_name PauseMenuController

signal quitted

@export var panel: Panel
@export var vbox0: VBoxContainer
@export var vbox1: VBoxContainer
@export var labels0: Array[Label]
@export var labels1: Array[Label]

const COLOR0: Color = Color(0.0, 0.0, 0.0, 1.0)
const COLOR1: Color = Color(0.482, 0.496, 0.207, 1.0)

var selection: Vector2i: #With setter
	set(val):
		SetUnSelect(selection)
		val.x = clamp(val.x, 0, 2)
		if val.y == 0:
			vbox1.hide()
			vbox0.show()
		else:
			vbox0.hide()
			vbox1.show()
		selection = val
		SetSelect(selection)

func SetSelect(sel: Vector2i) -> void:
	var ls: LabelSettings = LabelSettings.new()
	ls.font = load("res://Textures/pixelart.ttf")
	ls.outline_size = 10
	ls.font_size = 14
	ls.outline_color = COLOR1
	if sel.y == 0:
		labels0[sel.x].label_settings = ls
	if sel.y == 1:
		labels1[sel.x].label_settings = ls
	


func SetUnSelect(sel: Vector2i) -> void:
	var ls: LabelSettings = LabelSettings.new()
	ls.font = load("res://Textures/pixelart.ttf")
	ls.outline_size = 10
	ls.font_size = 14
	ls.outline_color = COLOR0
	if sel.y == 0:
		labels0[sel.x].label_settings = ls
	if sel.y == 1:
		labels1[sel.x].label_settings = ls
	


func _ready() -> void:
	_DisableNode(panel)

func _DisableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func _EnableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()

func EnterPause() -> void:
	_EnableNode(panel)
	selection = Vector2i.ZERO

func QuitPause() -> void:
	_DisableNode(panel)
	quitted.emit()

func Next() -> void:
	selection.x += 1

func Previous() -> void:
	selection.x -= 1

func Select() -> void:
	if selection.y == 0:
		match selection.x:
			0:
				QuitPause()
			1:
				selection.y = 1
				selection.x = 0
			2:
				get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	if selection.y == 1:
		if selection.x == 2:
			selection.y = 0
			selection.x = 0

func SideMov(val: int) -> void:
	if val == 0: return
	var val_: int = sign(val)
	if selection.y == 1:
		match selection.x:
			0:
				Configs.volume += val_
				labels1[0].text = "Volume: < " + str(Configs.volume) + " >"
			1:
				Configs.controle_ind += val_
				labels1[1].text = "Controle: < " + str(Configs.controle) + " >"
	
