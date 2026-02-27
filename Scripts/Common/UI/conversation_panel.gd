extends Control
class_name ConversationPanel

signal finished

@export var text: Label
@export var name_l: Label
@export var name_r: Label
@export var img_l: TextureRect
@export var img_r: TextureRect

var _parent: ConversationController
var _show_speed: float = 40.0

func _ready() -> void:
	_parent = get_parent()

func Show(anim: bool) -> void:
	if anim:
		var tween: Tween = create_tween()
		tween.tween_property(
			self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2
		).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)

func Hide(anim: bool) -> void:
	if anim:
		var tween: Tween = create_tween()
		tween.tween_property(
			self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2
		).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
	else:
		modulate = Color(0.0, 0.0, 0.0, 0.0)

func Display(sd: SpeakerData) -> void:
	if sd.side_left:
		img_r.modulate.a = 0.3
		name_r.modulate.a = 0.3
		img_l.modulate.a = 1.0
		name_l.modulate.a = 1.0
		img_l.texture = sd.speaker_texture
		name_l.text = sd.speaker_name
	else:
		img_l.modulate.a = 0.3
		name_l.modulate.a = 0.3
		img_r.modulate.a = 1.0
		name_r.modulate.a = 1.0
		img_r.texture = sd.speaker_texture
		name_r.text = sd.speaker_name
	
	
	for i in sd.messages.size():
		text.text = sd.messages[i]
		text.visible_ratio = 0.0
		var tween: Tween = create_tween()
		tween.tween_property(
			text, "visible_characters", sd.messages[i].length(), sd.messages[i].length() / _show_speed
		).set_trans(Tween.TRANS_LINEAR)
		await tween.finished
		await _parent.resume
	
	finished.emit()
	
