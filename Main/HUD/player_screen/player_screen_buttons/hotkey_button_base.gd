extends Control

@export var margin_animation_offset : Vector2
@export var custom_label_default_position := Vector2(0, 32)
@export var label_animation_offset : Vector2
@export var input_action : String
@export_enum("driving_gyro_enabled") var global_variable_reference : String
var toggle_state := false
var state_tweener 
var margin_tweener 
var cooldown := false

var default_margin_position : Vector2
var margin_position_offset : Vector2
var default_label_position : Vector2
var label_position_offset : Vector2

@onready var margin = $Control/automaticDrivingMargin
@onready var state_label = $Control/automaticDrivingMargin/state_label

var user_prefs_instance : userPrefs

func _ready() -> void:
	load_user_prefs()
	await get_tree().create_timer(0.1).timeout
	default_margin_position = margin.position
	margin_position_offset = default_margin_position + margin_animation_offset
	
	default_label_position = state_label.position
	label_position_offset = default_label_position + label_animation_offset
	
func load_user_prefs() -> void:
	if !global_variable_reference:
		return
	user_prefs_instance = userPrefs.load_or_create()
	toggle_state = user_prefs_instance.get(global_variable_reference)
	animate_state_label()

func _on_hotkey_button_pressed() -> void:
	Input.action_press($hotkeyButton.action)

func _process(delta: float) -> void:
	if !input_action:
		return
	if Input.is_action_just_pressed(input_action):
		#This toggles the bool var
		toggle_state = !toggle_state
		animate_state_label()
		animate_margin()

func animate_margin() -> void:
	if margin_tweener:
		margin_tweener.kill()
	margin_tweener = create_tween().set_parallel()
	margin_tweener.tween_property(margin, "position", margin_position_offset, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	margin_tweener.tween_property(margin, "modulate:a", 1, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$inactiveTimer.start()

func animate_state_label() -> void:
	if state_tweener:
		state_tweener.kill()
	state_tweener = create_tween().set_parallel(true)
	if toggle_state:
		state_label.text = "[center]ON"
		#Turn the label yellow and jump
		state_tweener.tween_property(state_label, "theme_override_colors/default_color", Color("fffc40"), 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		state_tweener.tween_property(state_label, "position:y", label_position_offset.y, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		state_tweener.chain().tween_property(state_label, "position:y", default_label_position.y, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	else:
		state_label.text = "[center]OFF"
		state_tweener.tween_property(state_label, "position:y", default_label_position.y, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		state_tweener.tween_property(state_label, "theme_override_colors/default_color", Color("242234"), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_inactive_timer_timeout() -> void:
	if margin_tweener:
		margin_tweener.kill()
	margin_tweener = create_tween().set_parallel()
	margin_tweener.tween_property(margin, "position", default_margin_position, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	margin_tweener.tween_property(margin, "modulate:a", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_cooldown_timer_timeout() -> void:
	cooldown = false

func _on_gui_input(event: InputEvent) -> void:
	if !input_action:
			return
	if event is InputEventScreenTouch:
		if event.pressed:
			if cooldown:
				return
			cooldown = true
			$CooldownTimer.start()
			$TextureButton.button_pressed = true
			Input.action_press(input_action)
		else:
			$TextureButton.button_pressed = false
			Input.action_release(input_action)
