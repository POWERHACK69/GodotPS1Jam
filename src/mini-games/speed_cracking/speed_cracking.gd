extends Control

@onready var display_label = $ColorRect/VBoxContainer/HBoxContainer/Label2
@onready var arrow_container = $ColorRect/HBoxContainer
@onready var response_label = $ColorRect/VBoxContainer/Label

@onready var timer = $Timer

var hacking_sequence = []  # Stores the JSON sequence
var current_index = 0  # Tracks progress in the sequence

var word_list = []
var arrow_map = {}
var input_index = 0
var displayed_text = ""  
var current_response = ""  
var time_limit = 5.0  

const ARROW_KEYS = [KEY_LEFT, KEY_UP, KEY_RIGHT, KEY_DOWN]
const ARROW_SYMBOLS = { KEY_LEFT: "←", KEY_UP: "↑", KEY_RIGHT: "→", KEY_DOWN: "↓" }

func _ready():
	load_hacking_sequence()
	start_next_command()

func load_hacking_sequence():
	var file = FileAccess.open("res://src/mini-games/speed_cracking/speed_cracking_data.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data and "hacking_sequence" in data:
			hacking_sequence = data["hacking_sequence"]  # Load full sequence
	else:
		print("Failed to load JSON file.")

func start_next_command():
	if current_index < hacking_sequence.size():
		var entry = hacking_sequence[current_index]
		setup_words(entry["command"])
		print(entry["command"])
		current_response = entry["response"]  # Store response
	else:
		print("HACK COMPLETE")
		response_label.text = "PROGRAM COMPLETE."  # Show final message

func setup_words(text):
	word_list = text.split(" ")
	arrow_map.clear()
	input_index = 0
	displayed_text = ""
	display_label.text = displayed_text  
	response_label.text = ""  

	# Clear previous arrows
	for child in arrow_container.get_children():
		child.queue_free()

	# Assign random arrows to words
	for word in word_list:
		var arrow_key = ARROW_KEYS.pick_random()
		arrow_map[word] = arrow_key
		
		var arrow_label = Label.new()
		arrow_label.text = ARROW_SYMBOLS[arrow_key]
		arrow_label.add_theme_font_size_override("font_size", 24)
		arrow_container.add_child(arrow_label)

func _input(event):
	if event is InputEventKey and event.pressed:
		if input_index < word_list.size():
			var expected_key = arrow_map[word_list[input_index]]
			if event.keycode == expected_key:
				add_word_to_screen()
				input_index += 1  
				if input_index >= word_list.size():
					game_won()
			else:
				game_lost()

func add_word_to_screen():
	if input_index == 0:
		displayed_text += word_list[input_index]
	else:
		displayed_text += " " + word_list[input_index]
	display_label.text = displayed_text  

func start_timer():
	timer.start(time_limit)

func _on_Timer_timeout():
	game_lost()

func game_won():
	print("ACCESS GRANTED")  
	response_label.text = current_response  
	response_label.visible_ratio = 0  # Start invisible

	# Create Tween node
	var tween := get_tree().create_tween()
	tween.tween_property(response_label, "visible_ratio", 1, 1.75)  # Fade-in over 0.8 seconds

	current_index += 1  # Move to next command in sequence
	await get_tree().create_timer(2.5).timeout  # Short delay before next command
	start_next_command()  # Load the next command


func game_lost():
	print("ACCESS DENIED")  
