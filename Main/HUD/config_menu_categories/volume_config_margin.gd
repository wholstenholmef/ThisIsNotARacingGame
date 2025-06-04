extends "res://Main/HUD/config_menu_categories/config_menu_category_base.gd"

var user_prefs_instance : userPrefs

func _ready() -> void:
	load_prefs()

func load_prefs() -> void:
	user_prefs_instance = userPrefs.load_or_create()
	%muteButton._on_toggled(user_prefs_instance.sound_mute)

func _on_mute_button_toggled(_state) -> void:
	AudioServer.set_bus_mute(0, _state)
	if user_prefs_instance:
		user_prefs_instance.sound_mute = _state
		user_prefs_instance.save()
