class_name Player
extends CharacterBody3D

@export var move_speed : float = 5.0
@export var rotate_speed : float = 3.0
@export var gravity : float = 9.8

@onready var interact_collision : CollisionShape3D = $Area3D/CollisionShape3D
@onready var pause_menu : PauseMenu =  get_tree().get_first_node_in_group("PauseMenu")
@onready var animation_tree := $AnimationTree

var is_pause_menu_open : bool = false
var platform_velocity : Vector3 = Vector3.ZERO

var interacting: bool = false


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

	if not interacting:
		if Input.is_action_pressed("forward"):
			input_dir.z += 1
			#footstep_sound()
		if Input.is_action_pressed("backward"):
			input_dir.z -= 0.5
			#footstep_sound()
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			input_dir.y += 1.3
			animation_tree.set("parameters/Jumping/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		if Input.is_action_pressed("left"):
			rotate_y(rotate_speed * delta)
		if Input.is_action_pressed("right"):
			rotate_y(-rotate_speed * delta)

		if Input.is_action_just_pressed("interact"):
			if $Area3D/CollisionShape3D.disabled == true:
				$Area3D/CollisionShape3D.disabled = false
				await get_tree().create_timer(0.2).timeout
				$Area3D/CollisionShape3D.disabled = true
	
		# Moves with the platform
		if is_on_floor():
			var collision = get_last_slide_collision()
			if collision:
				var collider = collision.get_collider()
				if collider and collider.is_in_group("platforms"):
					global_transform.origin += collider.delta_position
	
	velocity += transform.basis * (input_dir * move_speed)
	velocity.y -= gravity * delta
	
	#print(animation_tree.get_root_motion_position().z)
	
	# Forwards and backwards animation
	var velocity_rotated = velocity * global_basis
	#print(velocity_rotated)
	var blended_amount = lerpf(animation_tree.get("parameters/Blend3/blend_amount"), (clampf(velocity_rotated.z, -1.0, 1.0)), 0.2)
	animation_tree.set("parameters/Blend3/blend_amount", blended_amount)
	animation_tree.set("parameters/RunBlend/blend_amount", clampf(velocity_rotated.z * 0.25, 0.0, 1.0))
	animation_tree.set("parameters/ForwardSpeed/scale", maxf(1.0, velocity_rotated.z * 0.5))
	animation_tree.set("parameters/BackwardSpeed/scale", -velocity_rotated.z * 0.95)
	
	# Falling animation
	if not is_on_floor() and velocity.y <= -2.0:
		animation_tree.set("parameters/Falling/blend_amount", lerpf(animation_tree.get("parameters/Falling/blend_amount"), 1.0, 0.02))
	else:
		animation_tree.set("parameters/Falling/blend_amount", 0.0)
	
	move_and_slide()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("terminal"):
		area.get_parent().start_mini_game()
		#print("beep boop")

func running_footstep_sound():
	$footstep_run.volume_db = -5
	$footstep_run.pitch_scale = randf_range(0.5, 1.5)
	if $footstep_run.playing == false:
		$footstep_run.play()


func footstep_sound():
	$footstep.volume_db = -5
	$footstep.pitch_scale = randf_range(0.5, 1.5)
	if $footstep.playing == false:
		$footstep.play()
