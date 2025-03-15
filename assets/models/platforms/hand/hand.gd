extends EnvironmentBody

@export var time_to_move: float = 2.0
@export var time_to_wait: float = 0.5

# Find Marker3D - best if it's position is set to 'Top Level'
@onready var Marker: Marker3D = find_child("Marker3D")
@export var should_return_on_deactivation = true

var start_pos: Vector3
var tween: Tween = null
var dummy_float: float = 0.0

var previous_position : Vector3
var delta_position : Vector3


func _ready():
	print(str(name) + " active: " + str(activated))
	start_pos = global_position
	if activated and Marker and start_pos:
		start_tween()
	previous_position = global_transform.origin


func _on_activated():
	if start_pos and Marker:
		start_tween()


func start_tween():
	print("tweening")
	
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "dummy_float", 1.0, time_to_wait)
	tween.tween_property(self, "global_position", Marker.global_position, time_to_move)
	tween.tween_property(self, "dummy_float", 0.0, time_to_wait)
	tween.tween_property(self, "global_position", start_pos, time_to_move)


func _on_deactivated():
	if tween:
		tween.kill()
	
	if should_return_on_deactivation:
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", start_pos, time_to_move)


func _physics_process(delta):
	delta_position = global_transform.origin - previous_position
	previous_position = global_transform.origin
	
	##global_position.z = start_pos.z - sin(fposmod(Time.get_ticks_msec() * 0.001 * (1/time_to_move), 1.0)  * PI) * 3.0
	#if not Marker:
		#return
	
	#var alpha = sin(smoothstep(0.0,1,(fposmod(Time.get_ticks_msec() * 0.001 * (1/time_to_move), 1.0))) * PI)
	#print(alpha)
	#global_position = lerp(start_pos, Marker.global_position, alpha)
