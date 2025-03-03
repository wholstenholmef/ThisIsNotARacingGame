extends "res://Main/HUD/config_menu_categories/config_menu_category_base.gd"

var user_prefs_instance : userPrefs

@onready var mute_button = $configContainer/VBoxContainer/muteButton
@onready var master_volume_button = $configContainer/VBoxContainer/masterVolumeButton
@onready var music_volume_button = $configContainer/VBoxContainer/musicVolumeButton
@onready var SFX_volume_button = $configContainer/VBoxContainer/SFXVolumeButton

func _ready() -> void:
	load_prefs()

func load_prefs() -> void:
	user_prefs_instance = userPrefs.load_or_create()
	mute_button._on_menu_button_toggled(user_prefs_instance.sound_mute)

func _on_mute_button_toggled(_state) -> void:
	AudioServer.set_bus_mute(0, _state)
	if user_prefs_instance:
		user_prefs_instance.sound_mute = _state
		user_prefs_instance.save()
