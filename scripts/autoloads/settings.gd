extends Node


var rotate_speed : float = 3.0

var player

func get_player(player_node):
	player = player_node
	
		
func change_player_speed(speed_value:float):
	if player != null:
		player.move_speed = speed_value
