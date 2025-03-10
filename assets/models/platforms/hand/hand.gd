extends AnimatableBody3D
var start_pos
func _ready():
	start_pos = global_position

func _physics_process(delta):
	global_position.z = start_pos.z - sin(fposmod(Time.get_ticks_msec() * 0.001 * 0.25, 1.0)  * PI) * 3.0
