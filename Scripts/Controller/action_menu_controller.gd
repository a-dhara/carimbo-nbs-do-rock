extends Node
class_name ActionMenuController

@export var panel: ActionMenuPanel
@export var entry_vbox: VBoxContainer

@export var entry_prefab: PackedScene

var menu_entries: Array[MenuEntry] = []
var selection: int

const character_offset: Vector2 = Vector2(12, -25)

func _ready() -> void:
	panel.SetHidden()
	_DisableNode(panel)

func _EnableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()

func _DisableNode(node: Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func StartEntries(options: Array[Texture2D]) -> void:
	_EnableNode(panel)
	Clear()
	for i in range(0, options.size(), 2):
		var entry: MenuEntry = MenuEntry.new(options[i], options[i+1])
		#stretch mode se precisar
		entry_vbox.add_child(entry)
		_EnableNode(entry)
		menu_entries.append(entry)
	SetSelection(0)

func Show(char_pos: Vector2) -> void:
	await panel.SetPosition(char_pos + character_offset, true)

func Hide() -> void:
	await panel.SetPosition(panel.position, false)
	panel.SetHidden()
	Clear()
	_DisableNode(panel)

func Clear() -> void:
	for e in menu_entries:
		if e.get_parent():
			e.get_parent().remove_child(e)
		e.free()
	menu_entries.clear()

func SetLocked(ind: int, val: bool) -> void:
	if ind < 0 || ind >= menu_entries.size(): return
	menu_entries[ind].locked = val
	if val and selection == ind:
		Next()

func Next() -> void:
	if menu_entries.size() == 0: return
	for i in range(selection + 1, menu_entries.size() + 2):
		var ind: int = i % menu_entries.size()
		if SetSelection(ind):
			break

func Previous() -> void:
	if menu_entries.size() == 0: return
	for i in range(selection - 1 + menu_entries.size(), selection, -1):
		var ind: int = i % menu_entries.size()
		if SetSelection(ind):
			break

func GetEntryByPosition(pos: Vector2) -> int:
	for i in range(menu_entries.size()):
		if Rect2(menu_entries[i].global_position, menu_entries[i].size).has_point(pos):
			return i
	return -1

func SetSelection(ind: int) -> bool:
	if menu_entries[ind].locked: return false
	
	if selection >= 0 and selection < menu_entries.size():
		menu_entries[selection].selected = false
	selection = ind
	if selection >= 0 and selection < menu_entries.size():
		menu_entries[selection].selected = true
	return true
