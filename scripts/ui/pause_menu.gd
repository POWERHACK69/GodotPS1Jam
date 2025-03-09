extends CanvasLayer
class_name PauseMenu

@onready var main_pause_menu : Control = $MainPauseMenu
@onready var options : Control = $OptionsMenu
@onready var focus_start : Button = $MainPauseMenu/VBoxContainer/ResumeButton
@onready var options_focus_start : HSlider = $OptionsMenu/VBoxContainer/ScrollContainer/OptionsContainer/TurningSpeed/HSlider

func _on_resume_button_pressed():
	get_tree().paused = false
	hide()

func _on_options_button_pressed() -> void:
	options.show()
	main_pause_menu.hide()
	options_focus_start.grab_focus()


func _on_back_button_pressed() -> void:
	main_pause_menu.show()
	options.hide()
	focus_start.grab_focus()
