class_name Player
extends CharacterBody3D

@export var move_speed := 5.0
@export var rotate_speed := 3.0
@export var gravity := 9.8

func _process(delta):
	velocity.x = 0
	velocity.z = 0

	var input_dir = Vector3()

	if Input.is_action_pressed("forward"):
		input_dir.z += 1
	if Input.is_action_pressed("backward"):
		input_dir.z -= 1
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		input_dir.y +=1.3

	velocity += transform.basis * (input_dir * move_speed)
	velocity.y -= gravity * delta
	move_and_slide()

	if Input.is_action_pressed("left"):
		rotate_y(rotate_speed * delta)
	if Input.is_action_pressed("right"):
		rotate_y(-rotate_speed * delta)
