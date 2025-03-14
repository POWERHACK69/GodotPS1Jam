extends AnimatableBody3D
class_name  EnvironmentBody

@export var activated : bool:
	set = on_state_changed

var last_state = false
var game_started = false


#func _ready():
	#game_started = true
	#on_state_changed(activated)
	#last_state = activated


# Called when 'activated' value is set
func on_state_changed(value):
	#if not game_started:
		#return
	activated = value
	
	print("last state: " + str(last_state))
	print("Current state: " + str(value))
	if last_state == value: # if nothing changed return
		return
	
	last_state = value
	
	if value:
		_on_activated()
	else:
		_on_deactivated()
		

func _on_activated():
	pass

func _on_deactivated():
	pass
