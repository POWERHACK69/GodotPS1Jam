extends CharacterBody3D

@export var speed : float = 5.0

@onready var navigation_agent_3d = $NavigationAgent3D

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	select_new_destination()
	

func _physics_process(delta: float) -> void:

	var destination = navigation_agent_3d.get_next_path_position()
	var direction_to_destination = destination - global_position
	var direction = direction_to_destination.normalized()
	
	velocity = direction * speed
	if not is_on_floor():
		velocity.y -=9.5
	#print(velocity)
	move_and_slide()

func select_new_destination():
	var random_position := Vector3.ZERO
	random_position.x = randf_range(-25.0, 25.0)
	random_position.z = randf_range(-25.0, 25.0)
	navigation_agent_3d.set_target_position(random_position)
	navigation_agent_3d.get_next_path_position()
	

func _on_navigation_agent_3d_navigation_finished() -> void:
	print("done")
	select_new_destination()
