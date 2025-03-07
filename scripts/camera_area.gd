extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if get_parent() is Camera3D:
		if body is Player and  get_parent().get_parent() != null:
			get_parent().get_parent().set_active_camera(get_parent())
				


func _on_body_exited(body: Node3D) -> void:
	if get_parent() is Camera3D:
		if body is Player:
			pass
