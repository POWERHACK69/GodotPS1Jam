extends CanvasLayer
class_name LoadingScreen
@onready var post_process_layer_branch = $"../PostProcessLayer/PSXLayer/BlurPostProcess/Viewport/LCDOverlay/Viewport/DitherBanding/Viewport"
@onready var label : Label = $Control/Label

var progress : Array = []
var scene_name
var scene_load_status = 0

func _ready():
	set_process(false)

func _process(delta) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	label.text = str(floor(progress[0]*100)) + "%"
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		var scene = new_scene.instantiate()
		post_process_layer_branch.get_children()[0].queue_free()
		post_process_layer_branch.add_child(scene)
		hide()

func load_level(level) -> void:
	scene_name = level
	set_process(true)
	ResourceLoader.load_threaded_request(scene_name)
	
