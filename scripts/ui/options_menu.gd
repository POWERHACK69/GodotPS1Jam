extends Control

@onready var turning_speed_slider : HSlider = $VBoxContainer/ScrollContainer/OptionsContainer/TurningSpeed/HSlider
@onready var turning_speed_line : LineEdit = $VBoxContainer/ScrollContainer/OptionsContainer/TurningSpeed/LineEdit

func _on_turning_speed_h_slider_value_changed(value : float) -> void:
	Settings.set_player_turning_speed(value)
	turning_speed_line.text = str(value)

func _on_turning_speed_line_edit_text_submitted(new_text : float) -> void:
	var value : float = float(new_text)
	clampf(value,0.5,6)
	turning_speed_slider.value = value
