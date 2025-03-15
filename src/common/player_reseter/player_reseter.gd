extends Area3D


func _on_body_entered(body):
	var marker = find_child("Marker3D")
	if marker and body and body.is_in_group("player"):
		body.global_position = marker.global_position
