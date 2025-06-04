class_name carNode
extends RigidBody3D

signal gyro_movement_toggled

@export var player_id : int = 1
@export_color_no_alpha var mesh_color = Color.WHITE
@onready var car_mesh = $Jupiter5
@onready var car_body_mesh = car_mesh.get_node("mainCar")

@onready var bael_character = preload("res://Main/racerCharacter/bael.tscn")
@onready var neptune_character = preload("res://Main/racerCharacter/neptune.tscn")
@onready var douche_character = preload("res://Main/racerCharacter/Douche.tscn")

@export var drift_camera_offset := Vector3.ZERO
var current_turbo_VFX : CPUParticles3D

var gyro_movement := false
var gyro_sensibility : float
var speed : float = 60
var normal_speed : float = 60
var drift_speed : float = 40
var braking_speed : float = 15

var steering : float = 21.0
var normal_steering : float = 35.0
var drift_steering : float = 60.0

var turn_speed : float = 2
var normal_turn_speed : float = 2
var drift_turn_speed : float = 0.1
var turn_stop_limit : float = 0.75
var mesh_tilt : int = 35
var mesh_offset = Vector3(0 , 0.6, 0)

var automatic_driving := false
var accelerate_input : float = 0
var steer_input : float = 0
var is_drifting := false
var drift_min_velocity : int = 16
var drift_direction := 0
var drift_time := 0.0

var small_boost_time := 1.0
var boost_time := 1.8
var super_boost_time := 3.2
var boost_force = 1.0
var current_boost_duration : float = 0.5
var is_boosting := false
var has_played_spark_sfx := false
var has_played_fire_sfx := false
var has_played_lightning_sfx := false

var target

var max_velocity := 48
var normal_max_velocity := 48
var boost_max_velocity = 60

var user_prefs_instance : userPrefs

var current_camera : Camera3D

func _ready() -> void:
	load_character()
	current_camera = get_viewport().get_camera_3d()
	$SFX/motorSFX.play()
	unemit_sparks_VFX()
	#$carMesh/body.get_active_material(0).albedo_color = mesh_color
	load_user_prefs()
	#car_body_mesh_offset = car_mesh.position

func load_character() -> void:
	var character_reference = Global.get("player_" + str(player_id) + "_character")
	print(character_reference)
	var character_path
	match character_reference:
		"Bael":
			character_path = bael_character
		"Neptune":
			character_path = neptune_character
		"Douche":
			character_path = douche_character
		_:
			character_path = bael_character
	var character_instance = character_path.instantiate()
	%characterMarker.add_child(character_instance)

func load_user_prefs() -> void:
	user_prefs_instance = userPrefs.load_or_create()
	#gyro_movement = user_prefs_instance.driving_gyro_enabled
	gyro_movement = false
	gyro_sensibility = user_prefs_instance.gyro_sensibility

func wheel_animation(delta) -> void:
	#$"carMesh/wheel-front-left".rotation.y = steer_input
	#$"carMesh/wheel-front-right".rotation.y = steer_input
	$Jupiter5/frontWheelL.rotation.y = steer_input
	$Jupiter5/frontWheelR.rotation.y = steer_input
	
	$Jupiter5/frontWheelL.rotation.x += linear_velocity.length() * delta
	$Jupiter5/frontWheelR.rotation.x += linear_velocity.length() * delta
	$Jupiter5/backWheelL.rotation.x += linear_velocity.length() * delta
	$Jupiter5/backWheelR.rotation.x += linear_velocity.length() * delta
	#$"carMesh/wheel-back-left".rotation.x += linear_velocity.length() * delta
	#$"carMesh/wheel-back-right".rotation.x += linear_velocity.length() * delta
	#$"carMesh/wheel-front-left".rotation.x += linear_velocity.length() * delta 
	#$"carMesh/wheel-front-right".rotation.x += linear_velocity.length() * delta

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if %groundRay.is_colliding():
		if linear_velocity.length() <= max_velocity+1: 
			apply_central_force(car_mesh.global_transform.basis.z * accelerate_input)
	#print(linear_velocity)

func respawn(spawn_point_instance) -> void:
	%circleTransition.fade_out()
	await %circleTransition.transition_finished
	%circleTransition.fade_in()
	
	accelerate_input = 0
	linear_velocity = Vector3.ZERO
	is_drifting = false
	unemit_sparks_VFX()
	self.global_transform = spawn_point_instance.global_transform
	car_mesh.global_transform = spawn_point_instance.global_transform

func _physics_process(delta: float) -> void:
	%cameraMarker.position = self.position
	car_mesh.position = self.position - mesh_offset
	wheel_animation(delta)
	
	%squareTurboVFX.rotation.z += delta * 3
	motor_SFX_effect()
	get_input()
	
	if %groundRay.is_colliding() == false:
		return
	
	if is_drifting:
		#steer_input = lerp(steer_input, 0.0, delta)
		if drift_direction == 1:
			if steer_input:
				steer_input = clamp(steer_input, -9, -0.15)
			else:
				steer_input = -0.5
		if drift_direction == -1:
			if steer_input:
				steer_input = clamp(steer_input, 0.15, 9)
			else:
				steer_input = 0.5
	
	if linear_velocity.length() > turn_stop_limit:
		var new_basis = car_mesh.global_transform.basis.rotated(car_mesh.global_transform.basis.y, steer_input)
		car_mesh.global_transform.basis = car_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		car_mesh.global_transform = car_mesh.global_transform.orthonormalized()
		#Model tilting
		var t = -steer_input * linear_velocity.length() / mesh_tilt
		car_body_mesh.rotation.z = lerp(car_body_mesh.rotation.z, t, 5.0 * delta)
		car_body_mesh.rotation_degrees.z = -clamp(car_body_mesh.rotation_degrees.z, -45, 45)
		#Align y to ground
		if %groundRay.is_colliding():
			var n = %groundRay.get_collision_normal()
			var xform = align_with_y(car_mesh.global_transform, n)
			car_mesh.global_transform = car_mesh.global_transform.interpolate_with(xform, 10.0 * delta)
	
	if is_drifting:
		drift_time += delta
		steering = drift_steering
		speed = drift_speed
		
		#Drift VFX Section
		%whiteSparks.set_deferred("emitting", true)
		%smokeCloud.set_deferred("emitting", true)
		%smokeTrail.set_deferred("emitting", true)
		
		if drift_direction == 1:
			%SparkVFX.position = $Jupiter5/RightTireMarker.position
			steer_input = 0
			#steer_input = clamp(steer_input, -9, 0)
			#print(steer_input)
			#steering = clamp(steering, 0, drift_steering)
		elif drift_direction == -1:
			%SparkVFX.position = $Jupiter5/LeftTireMarker.position
			#steering = clamp(steering, 0, drift_steering)
		#if steer_input == 0:
			#is_drifting = false
			#%cinematicBars.focus_out()
		
		if drift_time >= small_boost_time:
			if !has_played_spark_sfx:
				%sparkSFX.pitch_scale = randf_range(1.0, 1.3)
				%sparkSFX.play()
				has_played_spark_sfx = true
			current_boost_duration = 0.2
			%whiteSparks.set_deferred("emitting", true)
			current_turbo_VFX = %smallTurboVFX
		if drift_time >= boost_time:
			if !has_played_fire_sfx:
				%fireSFX.pitch_scale = randf_range(0.8, 1.2)
				%fireSFX.play()
				has_played_fire_sfx = true
			current_boost_duration = 0.5
			%blueSparks.set_deferred("emitting", false)
			%smokeTrail.set_deferred("emitting", false)
			%fireSparks.set_deferred("emitting", true)
			%blackSmokeCloud.set_deferred("emitting", true)
			%blackSmokeTrail.set_deferred("emitting", true)
			current_turbo_VFX = %FireTurboVFX
		if drift_time >= super_boost_time:
			if !has_played_lightning_sfx:
				%lightningSFX.pitch_scale = randf_range(0.8, 1.2)
				%lightningSFX.play()
				has_played_lightning_sfx = true
			current_boost_duration = 1.25
			%fireSparks.set_deferred("emitting", false)
			%blackSmokeCloud.set_deferred("emitting", false)
			%blackSmokeTrail.set_deferred("emitting", false)
			%whiteSparks.set_deferred("emitting", true)
			%superSparks.set_deferred("emitting", true)
			%squareTurboVFX.set_deferred("emitting", true)
			current_turbo_VFX = %squareTurboVFX
	else:
		drift_time = 0
		steering = normal_steering
		speed = normal_speed
		has_played_spark_sfx = false
		has_played_fire_sfx = false
		has_played_lightning_sfx = false
	
	if is_boosting:
		#linear_velocity.length() = clamp(linear_velocity.length(), -30, 30)
		speed = normal_speed * 2
		max_velocity = boost_max_velocity
		if current_turbo_VFX:
			current_turbo_VFX.set_deferred("emitting", true)
	else:
		speed = normal_speed
		max_velocity = normal_max_velocity
		if current_turbo_VFX:
			current_turbo_VFX.set_deferred("emitting", false)
			%squareTurboVFX.set_deferred("emitting", false)
		
		#if !is_drifting:
			#square_turbo_VFX.set_deferred("emitting", false)
		#else:
			#square_turbo_VFX.set_deferred("amount", 6)

func get_input() -> void:
	accelerate_input = 0
	if automatic_driving:
		accelerate_input = 1 * speed
	else:
		if Input.is_action_pressed("accelerate_" + str(player_id)):
			accelerate_input = 1 * speed
	
	if Input.is_action_pressed("brake_" + str(player_id)):
		if accelerate_input == 0:
			accelerate_input = -1 * speed
	if Input.is_action_just_pressed("brake_" + str(player_id)):
		#Camera pan
		current_camera.set_offset(drift_camera_offset)
		
		if linear_velocity.length() < drift_min_velocity:
			return
		if accelerate_input > 0 and steer_input != 0:
			%driftSFX.play()
			is_drifting = true
			drift_direction = steer_input
			%cinematicBars.focus_in()
			if steer_input > 0:
				drift_direction = -1
			else:
				drift_direction = 1
	if Input.is_action_just_released("brake_" + str(player_id)):
		current_camera.set_offset()
		%driftSFX.stop()
		unemit_sparks_VFX()
		%cinematicBars.focus_out()
		if is_drifting:
			is_drifting = false
			boost(drift_time)
	
	if Input.is_action_just_pressed("toggle_gyro"):
		toggle_gyro()
	
	if Input.is_action_just_pressed("auto_acceleration_1", false):
		toggle_automatic_driving()

	#This limits the steering if is drifting
	#Creating a mario kart wii drift like
	#steer_input = (-Input.get_accelerometer().x * 0.2) * deg_to_rad(steering)
	#$Label.text = str(Input.get_accelerometer())
	if gyro_movement:
		#print("gyro")
		steer_input = (-Input.get_accelerometer().x * 0.2) * deg_to_rad(steering)
	else:
		steer_input = Input.get_axis("steer_right_" + str(player_id), "steer_left_" + str(player_id)) * deg_to_rad(steering)

func toggle_gyro() -> void:
	#Toggle the gyro state between true and false
	gyro_movement = !gyro_movement
	gyro_movement_toggled.emit(gyro_movement)
	if user_prefs_instance:
		user_prefs_instance.driving_gyro_enabled = gyro_movement
		user_prefs_instance.save()

func toggle_automatic_driving() -> void:
	automatic_driving = !automatic_driving

func boost(_drift_time) -> void:
	if drift_time < small_boost_time:
		return
	boost_force = 0
	if drift_time >= small_boost_time and drift_time < boost_time:
		boost_force = 10
	elif drift_time >= drift_time and drift_time < super_boost_time:
		boost_force = 30
	elif drift_time >= super_boost_time:
		boost_force  = 60
	
	is_boosting = true
	$boostTimer.wait_time = current_boost_duration
	$boostTimer.start()
	apply_central_impulse(car_mesh.global_transform.basis.z * boost_force)
	
	%turboSFX.pitch_scale = randf_range(0.9, 1.1)
	%turboSFX.play()

func _on_boost_timer_timeout() -> void:
	#apply_central_impulse(-$carMesh.global_transform.basis.z * (accelerate_input/5))
	is_boosting = false

func motor_SFX_effect() -> void:
	%motorSFX.pitch_scale = (linear_velocity.length() / 80) + 0.5
	%driftSFX.pitch_scale = (linear_velocity.length() / 20) + 0.5

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
#	xform.basis = xform.basis.orthonormalized()
	return xform.orthonormalized()

func unemit_sparks_VFX() -> void:
	for VFX in %SparkVFX.get_children():
		if VFX is CPUParticles3D:
			VFX.set_deferred("emitting", false)

func _on_target_area_body_entered(body: Node3D) -> void:
	if !body.is_in_group("Target"):
		return
	target = body

func _on_target_area_body_exited(body: Node3D) -> void:
	if !body.is_in_group("Target"):
		return
	target = null
