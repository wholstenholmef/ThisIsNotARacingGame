extends Node

@export_node_path("carNode") var target_player
@export var small_hud := false

@onready var drift_control = $hudElements/driftHUDControl
@onready var speed_label = $hudElements/MilesControl/MilesContainer/SpeedLabel
@onready var drift_HUD_control = $hudElements/driftHUDControl/MarginContainer
@onready var drift_timer_label = $hudElements/driftHUDControl/MarginContainer/driftTimerLabel
@onready var drift_progress_bar = $hudElements/driftHUDControl/MarginContainer/driftProgressBar

@onready var miles_container = $hudElements/MilesControl/MilesContainer
@onready var drift_container = $hudElements/driftHUDControl/MarginContainer

@onready var accelerate_button = $touchScreenButtonsCanvasLayer/buttonsContainer/accelerateButtonControl
@onready var steer_joystick = $"joystickCanvasLayer/MarginContainer/joystickControl/Virtual Joystick"

@onready var auto_accelerate_hotkey_button = $hotkeysCanvasLayer/buttonsContainer/AutoAccelerateHotkeyButton/TextureButton
@onready var gyro_toggle_hotkey_button = $hotkeysCanvasLayer/buttonsContainer/GyroHotkeyButton/TextureButton

var user_prefs_instance : userPrefs

func _ready() -> void:
	load_user_prefs()
	if target_player:
		target_player = get_node(target_player)
	
	if small_hud:
		miles_container.scale = Vector2(0.5, 0.5)
		drift_container.scale = Vector2(0.5, 0.5)
		
	#if !OS.get_name() == "Android":
		#$touchScreenButtonsCanvasLayer.hide()
		#$joystickCanvasLayer.hide()
		#auto_accelerate_hotkey_button.hide()
		#gyro_toggle_hotkey_button.hide()

func load_user_prefs() -> void:
	user_prefs_instance = userPrefs.load_or_create()
	_on_car_node_gyro_movement_toggled(user_prefs_instance.driving_gyro_enabled)

func _process(delta: float) -> void:
	if !target_player:
		return
	speed_label.text = str(int(target_player.linear_velocity.length()))

func _on_car_node_gyro_movement_toggled(_state) -> void:
	if _state:
		accelerate_button.show()
		steer_joystick.hide()
	else:
		accelerate_button.hide()
		steer_joystick.show()
