extends "res://scripts/environment_body_3d.gd"

#func _ready():
	#await get_tree().create_timer(2.0).timeout
	#$AnimationPlayer.play("door_open")

func _on_activated():
	$AnimationPlayer.play("door_open")
	
