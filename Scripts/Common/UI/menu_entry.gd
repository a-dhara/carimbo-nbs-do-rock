extends TextureRect
class_name MenuEntry

@export var _tex_normal: Texture2D
@export var _tex_selected: Texture2D

var selected: bool:
	set(value):
		selected = value
		if selected:
			texture = _tex_selected
		else:
			texture = _tex_normal

var locked: bool:
	set(value):
		locked = value
		if value:
			modulate = Color(0.0, 0.0, 0.0, 0.0)
		else:
			modulate = Color(1.0, 1.0, 1.0, 1.0)

func _init(ntex: Texture2D, stex: Texture2D) -> void:
	_tex_normal = ntex
	_tex_selected = stex
	texture = _tex_normal
