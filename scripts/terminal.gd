extends StaticBody3D

@export var affected_objects: Array[EnvironmentBody]
@export var mini_game: PackedScene
@export_enum("Toggle", "Switch", "Activate", "Deactivate") var type : String = "Toggle"
@export var dev_mode : bool

var mini_game_instance: CanvasLayer
var mini_game_passed: bool = false
var mini_game_in_progress = false

func start_mini_game():
	if dev_mode:
		mini_game_passed = true
	else:
		if not mini_game_in_progress:
			mini_game_in_progress = true
			if Settings.player:
				Settings.player.interacting = true
			$Interact.play()
			if mini_game:
				mini_game_instance = mini_game.instantiate()
				get_tree().current_scene.add_child(mini_game_instance) # Spawns mini-game in the scene
				mini_game_instance.register(self)
			else:
				end_mini_game()

func end_mini_game():
	
	if mini_game_instance:
		mini_game_instance.queue_free()
	
	if mini_game_passed:
		$Success.play()
	else:
		$Fail.play()
	
	mini_game_in_progress = false
	if Settings.player:
		await get_tree().create_timer(0.75).timeout
		Settings.player.interacting = false
		

func _process(delta: float) -> void:
	if mini_game_passed:
		print("terminal hacked")
		if type == "Toggle":
			for object in affected_objects:
				object.activated = !object.activated
				
		if type == "Switch":
			if affected_objects != null:
				affected_objects[0].activated = !affected_objects[0].activated
				for object in affected_objects:
					if object != affected_objects[0]:
						object.activated = !affected_objects[0]
						
		if type == "Activate":
			for object in affected_objects:
				object.activated = true
				object._on_activated()
				
		if type == "Deactivate":
			for object in affected_objects:
				object.activated = false
					
		mini_game_passed = false
