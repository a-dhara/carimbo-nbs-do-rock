extends Node2D

@export var anim_player: AnimationPlayer
@export var vbox: VBoxContainer
@export var labels: Array[Label]
@export var audio_sp: AudioStreamPlayer

var _started: bool = false
var _in_anim: bool = false

var _color0: Color = Color(0.0, 0.0, 0.0, 1.0)
var _color1: Color = Color(0.482, 0.496, 0.207, 1.0)

var selection: int:
	set(value):
		var ls: LabelSettings = LabelSettings.new()
		ls.font = load("res://Textures/pixelart.ttf")
		ls.outline_size = 10
		ls.font_size = 14
		ls.outline_color = _color0
		labels[selection].label_settings = ls
		selection = value % 3
		var ls1: LabelSettings = LabelSettings.new()
		ls1.font = load("res://Textures/pixelart.ttf")
		ls1.outline_size = 10
		ls1.font_size = 14
		ls1.outline_color = _color1
		labels[selection].label_settings = ls1

var _ver: Repeater = Repeater.new("move_up", "move_down")


func _ready() -> void:
	anim_player.play("init")

func _process(_delta: float) -> void:
	if not _started and not _in_anim and Input.is_action_just_pressed("select"):
		anim_player.play("play_menu")
		audio_sp.play()
		_in_anim = true
		await anim_player.animation_finished
		_started = true
		_in_anim = false
		selection = 0
	
	if _started and not _in_anim:
		var y = _ver.Update()
		if y < 0:
			selection -= 1
		elif y > 0:
			selection += 1
		if Input.is_action_just_pressed("select"):
			match selection:
				0:
					var tween: Tween = create_tween()
					tween.tween_property(audio_sp, "volume_db", -80, 2.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
					anim_player.play("leave")
					await anim_player.animation_finished
					get_tree().change_scene_to_file("res://Scenes/combate.tscn")
				1:
					print("configs")
				2:
					get_tree().quit()
				
	
