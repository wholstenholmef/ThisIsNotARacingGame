extends "res://Main/HUD/menu_button/menu_button.gd"

@export var audio_bus_index : int = 0
@export var default_index := 3

var max_checkboxes : int = 0
var current_index : int = 0
var checkboxes_array

var user_prefs_instance : userPrefs

func _ready() -> void:
	super()
	#the -2 max_checkboxes are textureRects for the sound icons
	checkboxes_array = $HBoxContainer.get_children()
	max_checkboxes = $HBoxContainer.get_child_count() - 2
	uncheck_boxes()
	load_user_prefs()
	#set_index(default_index)

func load_user_prefs() -> void:
	user_prefs_instance = userPrefs.load_or_create()
	print(user_prefs_instance.master_volume)
	match audio_bus_index:
		0: #Master bus
			set_index(user_prefs_instance.master_volume)
		1: #Music bus
			set_index(user_prefs_instance.music_volume)
		2: #SFX bus
			set_index(user_prefs_instance.SFX_volume)

func _on_menu_button_pressed() -> void:
	#I repeat the fucking animation here because i dont want to randomize the pitch scale for this button
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(self, "scale:y", 0.5, 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tweener.tween_property(self, "scale:y", 1, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

	#Sum the current index on button pressed
	#Then we compare these to the max. checkboxes
	#We reset and uncheck every button if it exceeds the maximum
	current_index += 1
	set_index(current_index)

	#Incremental pitch scale based on the current index
	if current_index != 0:
		$clickSFX.pitch_scale = (current_index / 2) + 0.5
	else:
		$clickSFX.pitch_scale = 0.4
	$clickSFX.play()
	
func set_index(_index) -> void:
	if _index > max_checkboxes:
		current_index = 0
		uncheck_boxes()
	else:
		current_index = _index
		check_box(current_index)
	$contentMargin/indexLabel.text = str(current_index)
	change_audio_bus()

func change_audio_bus() -> void:
	var index_to_volume : float = remap(current_index, 0, 5, 0, 1)
	AudioServer.set_bus_volume_db(0, linear_to_db(index_to_volume))
	if user_prefs_instance:
		match audio_bus_index:
			0: #Master bus
				user_prefs_instance.master_volume = current_index
			1: #Music bus
				user_prefs_instance.music_volume = current_index
			2: #SFX bus
				user_prefs_instance.SFX_volume = current_index
		user_prefs_instance.save()

func uncheck_boxes() -> void:
	for node in $HBoxContainer.get_children():
		if !(node is CheckBox):
			continue
		node.button_pressed = false

func check_box(index) -> void:
	if index == 0:
		return
	get_node("HBoxContainer/CheckBox" + str(index)).button_pressed = true
