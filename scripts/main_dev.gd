extends Node3D

@onready var post_process_layer_branch = $PostProcessLayer/PSXLayer/BlurPostProcess/Viewport/LCDOverlay/Viewport/DitherBanding/Viewport
@export var level_to_be_loaded : PackedScene
@export var load_middle_levels : bool

func _ready():
	if load_middle_levels:
		var new_scene = level_to_be_loaded.instantiate()
		post_process_layer_branch.get_children()[0].queue_free()
		post_process_layer_branch.add_child(new_scene)
