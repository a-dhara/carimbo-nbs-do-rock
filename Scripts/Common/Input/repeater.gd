class_name Repeater

const _rate: int = 250

var _next: int
var _axis_pos: String
var _axis_neg: String

func _init(neg_axis: String, pos_axis: String) -> void:
	_axis_neg = neg_axis
	_axis_pos = pos_axis

func Update() -> int:
	var ret_val: int = 0
	var value: int = roundi(Input.get_axis(_axis_neg, _axis_pos))
	
	if value != 0:
		if Time.get_ticks_msec() > _next:
			ret_val = value
			_next = Time.get_ticks_msec() + _rate
	else:
		_next = 0
	return ret_val
