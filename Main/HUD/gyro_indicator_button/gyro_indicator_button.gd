extends TouchScreenButton

var input_x
var active : bool = false

var tilt_right_texture = preload("res://Assets/HUD/Icons/Tilt/phone_tilt_2.png")
var tilt_left_texture = preload("res://Assets/HUD/Icons/Tilt/phone_tilt_1.png")
var tilt_still_texture = preload("res://Assets/HUD/Icons/Tilt/phone_tilt_3.png")

func _ready() -> void:
	#if Input.get_accelerometer() == Vector3.ZERO:
		#self.hide()
	texture_normal = tilt_still_texture
	pass

func _process(delta: float) -> void:
	#if Input.get_accelerometer() == Vector3.ZERO:
		#return
	input_x = -Input.get_accelerometer().x * 0.2 
	if input_x >= 0.1:
		texture_normal = tilt_right_texture
	elif input_x <= 0.1:
		texture_normal = tilt_left_texture
	else:
		texture_normal = tilt_still_texture
