extends Control
class_name ActionMenuPanel

@export var vbox: VBoxContainer

## Desaparece com o painel
func SetHidden() -> void:
	ToPosition(Vector2.ZERO, false, false)
	scale = Vector2.ZERO

## Move o painel até a posição
func SetPosition(pos: Vector2, showp: bool) -> void:
	await ToPosition(pos, showp, true)


func ToPosition(pos: Vector2, showp: bool, anim: bool) -> void:
	position = pos
	var nscale: Vector2
	if showp: nscale = Vector2(1,1)
	else: nscale = Vector2(0,0)
	if anim:
		var tween: = create_tween()
		tween.tween_property(
			self, "scale", nscale, 0.5
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
