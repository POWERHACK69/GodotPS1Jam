extends Control

@onready var turning_speed_slider : HSlider = $VBoxContainer/ScrollContainer/OptionsContainer/TurningSpeed/HSlider
@onready var turning_speed_line : LineEdit = $VBoxContainer/ScrollContainer/OptionsContainer/TurningSpeed/LineEdit

var turning_speed : float = 3.0

func _on_turning_speed_h_slider_value_changed(value) -> void:
	turning_speed = value
	turning_speed_line.text = str(value)

func _on_turning_speed_line_edit_text_submitted(new_text) -> void:
	var value : float = float(new_text)
	clampf(value,0.5,6)
	turning_speed_slider.value = value
