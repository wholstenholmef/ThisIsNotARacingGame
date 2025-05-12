class_name userPrefs
extends Resource

##Controls preferences
@export var driving_gyro_enabled := true
@export var gyro_sensibility := 0.002

##Volume preferences
@export var sound_mute := false
@export var master_volume : int = 3
@export var music_volume : int = 3
@export var SFX_volume : int = 3

func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")

static func create_() -> userPrefs:
	var res = userPrefs.new()
	return res

static func save_exists() -> bool :
	var res : userPrefs = load("user://user_prefs.tres") as userPrefs
	if res:
		return true
	else:
		return false

static func load_or_create() -> userPrefs:
	var res : userPrefs = load("user://user_prefs.tres") as userPrefs
	if !res:
		res = userPrefs.new()
	return res
