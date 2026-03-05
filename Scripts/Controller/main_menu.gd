extends Node2D

@export var anim_player: AnimationPlayer
@export var vbox0: VBoxContainer
@export var vbox1: VBoxContainer
@export var labels: Array[Label]
@export var labelsc: Array[Label]
@export var audio_sp: AudioStreamPlayer
@export var input_controller: InputController
@export var front_sprite: Sprite2D

var _started: bool = false
var _in_anim: bool = false

const COLOR0: Color = Color(0.0, 0.0, 0.0, 1.0)
const COLOR1: Color = Color(0.482, 0.496, 0.207, 1.0)

var selection: Vector2i: #With setter
	set(val):
		SetUnSelect(selection)
		val.x = clamp(val.x, 0, 2)
		if val.y == 0:
			vbox1.hide()
			vbox0.show()
			front_sprite.show()
		else:
			vbox0.hide()
			front_sprite.hide()
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
		labels[sel.x].label_settings = ls
	if sel.y == 1:
		labelsc[sel.x].label_settings = ls


func SetUnSelect(sel: Vector2i) -> void:
	var ls: LabelSettings = LabelSettings.new()
	ls.font = load("res://Textures/pixelart.ttf")
	ls.outline_size = 10
	ls.font_size = 14
	ls.outline_color = COLOR0
	if sel.y == 0:
		labels[sel.x].label_settings = ls
	if sel.y == 1:
		labelsc[sel.x].label_settings = ls



func _ready() -> void:
	anim_player.play("init")
	Configs.volume_changed.connect(OnVolChanged)
	input_controller.press_event.connect(OnPress)
	input_controller.move_event.connect(OnMove)


func OnMove(e: Vector2i) -> void:
	if _started and not _in_anim:
		if e.y != 0:
			selection.x += e.y
		if e.x != 0:
			if selection.y == 1:
				match selection.x:
					0:
						Configs.volume += e.x
						labelsc[0].text = "Volume: < " + str(Configs.volume) + " >"
					1:
						Configs.controle_ind += e.x
						labelsc[1].text = "Controle: < " + str(Configs.controle) + " >"


func OnPress(e: bool) -> void:
	if e:
		if not _started and not _in_anim:
			StartScene()
	if e and _started and not _in_anim:
		if selection.y == 0:
			match selection.x:
				0:
					var tween: Tween = create_tween()
					tween.tween_property(audio_sp, "volume_db", -80, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
					anim_player.play("leave")
					await anim_player.animation_finished
					get_tree().change_scene_to_file("res://Scenes/combate.tscn")
				1:
					selection.y = 1
					selection.x = 0
				2:
					get_tree().quit()
		elif selection.y == 1:
			if selection.x == 2:
				selection.y = 0
				selection.x = 0


func StartScene() -> void:
	anim_player.play("play_menu")
	audio_sp.play()
	_in_anim = true
	await anim_player.animation_finished
	_started = true
	_in_anim = false
	selection.x = 0



func OnVolChanged(val: int) -> void:
	audio_sp.volume_linear = float(val) / 20


func _exit_tree() -> void:
	input_controller.move_event.disconnect(OnMove)
	input_controller.press_event.disconnect(OnPress)
