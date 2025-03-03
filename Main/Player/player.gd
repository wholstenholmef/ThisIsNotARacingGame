extends CharacterBody3D

@export var gravity : float = -9.8
@export var wheel_base : float = 0.6
@export var steering_limit : float = 10.0
@export var speed : float = 6.0
@export var braking : float = 9.0
@export var friction : float = -2.0
@export var drag : float = -2.0
@export var max_speed_reverse : float = 3.0

@export_category("Traction/Braking")
@export var slip_speed = 9.0
@export var traction_slow = 0.75
@export var traction_fast = 0.02

var acceleration := Vector3.ZERO
var steer_angle : float = 0.0
var drifting = false

func _physics_process(delta: float) -> void:
	if is_on_floor():
		get_input()
		apply_friction(delta)
		calculate_steering(delta)
	acceleration.y = gravity
	velocity += acceleration * delta
	move_and_slide()

func apply_friction(delta) -> void:
	if velocity.length() < 0.2 and acceleration.length() == 0:
		velocity.x = 0
		velocity.z = 0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func calculate_steering(delta) -> void:
	if !drifting and velocity.length() > slip_speed:
		drifting = true
	if drifting and velocity.length() < slip_speed and steer_angle == 0:
		drifting = false
		
	var traction = traction_fast if drifting else traction_slow
	
	var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	var front_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(transform.basis.y, steer_angle)
	var new_heading = rear_wheel.direction_to(front_wheel)
	
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		#velocity = new_heading * velocity.length()
		velocity = lerp(velocity, new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	if new_heading != Vector3.ZERO:
		look_at(transform.origin + new_heading, transform.basis.y)

func get_input() -> void:
	var turn_vector = Input.get_action_strength("steer_left") - Input.get_action_strength("steer_right")
	steer_angle = turn_vector * deg_to_rad(steering_limit)
	$race.rotation.y = steer_angle + deg_to_rad(180)
	
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("accelerate"):
		acceleration = -transform.basis.z * speed
	elif Input.is_action_pressed("brake"):
		acceleration = transform.basis.z * braking
