extends Control

@onready var display_label = $ColorRect/Label
@onready var arrow_container = $ColorRect/HBoxContainer
@onready var timer = $Timer

var word_list = []
var arrow_map = {}
var input_index = 0
var time_limit = 120.0  # Seconds per round

const ARROW_KEYS = [KEY_LEFT, KEY_UP, KEY_RIGHT, KEY_DOWN]
const ARROW_SYMBOLS = { KEY_LEFT: "←", KEY_UP: "↑", KEY_RIGHT: "→", KEY_DOWN: "↓" }

func _ready():
	load_crack_string()
	start_timer()

func load_crack_string():
	var file = FileAccess.open("res://src/mini-games/speed_cracking/speed_cracking_data.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data and "strings" in data:
			var random_string = data["strings"].pick_random()
			setup_words(random_string)
	else:
		print("Failed to load JSON file.")

func setup_words(text):
	word_list = text.split(" ")
	arrow_map.clear()
	input_index = 0
	display_label.text = text

	# Clear previous arrows
	for child in arrow_container.get_children():
		child.queue_free()

	# Assign random arrows to words
	for word in word_list:
		var arrow_key = ARROW_KEYS.pick_random()
		arrow_map[word] = arrow_key
		
		# Display corresponding arrow symbol
		var arrow_label = Label.new()
		arrow_label.text = ARROW_SYMBOLS[arrow_key]
		arrow_label.add_theme_font_size_override("font_size", 24)
		arrow_container.add_child(arrow_label)

func _input(event):
	if event is InputEventKey and event.pressed:
		if input_index < word_list.size():
			var expected_key = arrow_map[word_list[input_index]]
			if event.keycode == expected_key:
				input_index += 1  # Move to next word
				if input_index >= word_list.size():
					game_won()
			else:
				game_lost()

func start_timer():
	timer.start(time_limit)

func _on_Timer_timeout():
	game_lost()

func game_won():
	print("ACCESS GRANTED")  # Replace with win feedback
	get_tree().reload_current_scene()

func game_lost():
	print("ACCESS DENIED")  # Replace with lose feedback
	get_tree().reload_current_scene()
