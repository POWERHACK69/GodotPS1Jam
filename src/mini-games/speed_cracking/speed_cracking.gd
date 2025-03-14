extends Control

@onready var display_label = $ColorRect/VBoxContainer/HBoxContainer/Label2
@onready var arrow_container = $ColorRect/HBoxContainer
@onready var response_label = $ColorRect/VBoxContainer/Label
@onready var text_timer: Timer = $ColorRect/TextTimer
@onready var time_progress_bar: TextureProgressBar = $ColorRect/TimeProgressBar

@onready var key_sound = preload("res://assets/sounds/sfx/key.wav")


var terminal

var hacking_sequence = []  # Stores the JSON sequence
var current_index = 0  # Tracks progress in the sequence

var word_list = []
var arrow_map = {}
var input_index = 0
var displayed_text = ""  
var current_response = ""  

const ARROW_ACTIONS = ["T-left", "T-up", "T-right", "T-down"]
var arrow_sprites = {
	"T-left": preload("res://assets/2d/keyboard/ARROWLEFT.png"),
	"T-up": preload("res://assets/2d/keyboard/ARROWUP.png"),
	"T-right": preload("res://assets/2d/keyboard/ARROWRIGHT.png"),
	"T-down": preload("res://assets/2d/keyboard/ARROWDOWN.png")
}


func _ready():
	var joypads = Input.get_connected_joypads()
	for joypad_id in joypads:
		var name = Input.get_joy_name(joypad_id).to_lower()
		
		if "xbox" in name:
			arrow_sprites = {
	"T-left": preload("res://assets/2d/xbox/X.png"),
	"T-up": preload("res://assets/2d/xbox/Y.png"),
	"T-right": preload("res://assets/2d/xbox/B.png"),
	"T-down": preload("res://assets/2d/xbox/A.png")
}

		elif "dualshock" in name or "playstation" in name or "ps4" in name or "ps3" in name or "dualsense" in name:
			arrow_sprites = {
	"T-left": preload("res://assets/2d/psx/SQUARE.png"),
	"T-up": preload("res://assets/2d/psx/TRIANGLE.png"),
	"T-right": preload("res://assets/2d/psx/CIRCLE.png"),
	"T-down": preload("res://assets/2d/psx/X.png")
}
		else:
			print("Unknown controller detected: ", name)

	load_hacking_sequence()
	start_next_command()

func _process(delta: float) -> void:
	time_progress_bar.value = text_timer.time_left * 10
	
func load_hacking_sequence():
	var file = FileAccess.open("res://src/mini-games/speed_cracking/speed_cracking_data.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if data and "hacking_sequence" in data:
			hacking_sequence = data["hacking_sequence"] 
	else:
		print("Failed to load JSON file.")

func start_next_command():
	if current_index < hacking_sequence.size():
		var entry = hacking_sequence[current_index]
		setup_words(entry["command"])
		#print(entry["command"])
		current_response = entry["response"]
		time_progress_bar.max_value = entry["time"] * 10
		time_progress_bar.value = entry["time"] * 10
		start_text_timer(entry["time"])
	else:
		#print("HACK COMPLETE")
		response_label.text = "PROGRAM COMPLETE."  # Show final message
		if terminal != null:
			terminal.mini_game_passed = true
			terminal.end_mini_game()

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

	# Assign random actions to words
	for word in word_list:
		var arrow_action = ARROW_ACTIONS.pick_random()
		arrow_map[word] = arrow_action
		
		var arrow_sprite = TextureRect.new()
		arrow_sprite.texture = arrow_sprites[arrow_action]
		arrow_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		arrow_sprite.custom_minimum_size = Vector2(42, 42)  # Adjust size as needed
		arrow_container.add_child(arrow_sprite)


func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton) and event.pressed:
		if input_index < word_list.size():
			var expected_action = arrow_map[word_list[input_index]]
			if Input.is_action_just_pressed(expected_action):
				$KeyboardSound.play_sound(key_sound)
				add_word_to_screen()
				input_index += 1  
				if input_index >= word_list.size():
					text_timer.stop()
					game_won()
			else:
				game_lost()


func add_word_to_screen():
	if input_index == 0:
		displayed_text += word_list[input_index]
	else:
		displayed_text += " " + word_list[input_index]
	display_label.text = displayed_text  

func start_text_timer(time_limit: float):
	text_timer.start(time_limit)

func _on_text_timer_timeout():
	game_lost()

func game_won():
	#print("ACCESS GRANTED")  
	response_label.text = current_response  
	response_label.visible_ratio = 0  # Start invisible

	# Create Tween node
	var tween := get_tree().create_tween()
	$AudioStreamPlayer.play()
	tween.tween_property(response_label, "visible_ratio", 1, 1.75)  # Fade-in over 1.75 seconds

	current_index += 1  # Move to next command in sequence
	await get_tree().create_timer(2.5).timeout  # Short delay before next command
	start_next_command()  # Load the next command

func game_lost():
	if terminal != null:
		terminal.mini_game_passed = false
		terminal.end_mini_game()
	#print("ACCESS DENIED")
