extends StaticBody3D

@export var affected_objects : Array[EnvironmentBody]


var mini_game_passed : bool


func start_mini_game():
	$Interact.play()
	

func end_mini_game():
	if mini_game_passed:
		$Success.play()
	else:
		$Fail.play()


func _process(delta: float) -> void:
	if mini_game_passed:
		for object in affected_objects:
			object.activated = !object.activated
			
		mini_game_passed = false
