extends AnimatableBody3D
class_name  EnvironmentBody

var last_state = false
@export var activated : bool:
	set = on_state_changed

func _ready():
	last_state = activated
	print("last state:" + str(last_state))

# Called when 'activated' value is set
func on_state_changed(value):
	if last_state == activated: # if nothing changed return
		return
	
	last_state = activated
	
	if activated:
		_on_activated()
	else:
		_on_deactivated()
		

func _on_activated():
	pass

func _on_deactivated():
	pass
