extends EnvironmentBody

@export var next_level = "res://src/levels/level1/level_1.tscn"

func _on_activated() -> void:
	var loading_screen : LoadingScreen = get_tree().get_first_node_in_group("LoadingScreen")
	loading_screen.show()
	loading_screen.load_level(next_level)
