extends Node3D

@export var player_node : Player

@onready var cameras = get_children()
var active_camera: Camera3D = null

func _ready():
	if cameras.is_empty():
		push_warning("No cameras found under CameraManager!")
		return
	
	# Set the first camera as active by default
	set_active_camera(cameras[0])

func set_active_camera(camera: Camera3D):
	if camera in cameras:
		# Disable all cameras
		for cam in cameras:
			cam.current = false
		
		# Enable the selected camera
		camera.current = true
		active_camera = camera
	else:
		push_warning("Tried to set an invalid camera as active!")

func get_current_camera() -> Camera3D:
	return active_camera

func _process(_delta: float) -> void:
	if !cameras.is_empty():
		active_camera.look_at(player_node.global_transform.origin, Vector3.UP)
