extends Node



func play_sound(sound):
	# This creates an AudioStreamPlayer2D on the fly and plays the sound.
	var player = AudioStreamPlayer2D.new()
	player.stream = sound
	player.volume_db = -5
	player.pitch_scale = randf_range(0.5, 1.5)
	add_child(player)
	player.play()
	
	#Queue the player for deletion once the sound is done
	player.connect("finished", Callable(player, "queue_free"))
