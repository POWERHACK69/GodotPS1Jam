extends Node


var rotate_speed : float = 3.0

var player : Player

func _ready() -> void:
	Engine.max_fps = 30  # Locks the game at 30 FPS

func get_player(player_node : Player) -> void:
	player = player_node

func change_player_speed(speed_value : float) -> void:
	if player != null:
		player.move_speed = speed_value

func set_player_turning_speed(value : float) -> void:
	player.rotate_speed = value
