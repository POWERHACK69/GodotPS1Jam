class_name Player
extends CharacterBody3D

@export var move_speed : float = 5.0
@export var rotate_speed : float = 3.0
@export var gravity : float = 9.8

@onready var interact_collision : CollisionShape3D = $Area3D/CollisionShape3D
@onready var pause_menu : PauseMenu =  $"../PauseMenu"

var is_pause_menu_open : bool = false

func _ready() -> void:
	Settings.get_player(self)
	rotate_speed = Settings.rotate_speed

func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = true
		pause_menu.show()
		pause_menu.focus_start.grab_focus()

func _process(delta):
	velocity.x = 0
	velocity.z = 0

	var input_dir : Vector3 = Vector3()

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

	if Input.is_action_just_pressed("interact"):
		if interact_collision.disabled == true:
			interact_collision.disabled = false
			await get_tree().create_timer(0.2).timeout
			interact_collision.disabled = true
