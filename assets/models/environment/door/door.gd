extends "res://scripts/environment_body_3d.gd"

#func _ready():
	#await get_tree().create_timer(2.0).timeout
	#activated = true
	#$AnimationPlayer.play("door_open")

func _on_activated():
	print("door activated")
	$AnimationPlayer.play("door_open")

func _on_deactivated():
	print("door deactivated")
	$AnimationPlayer.play_backwards("door_open")
