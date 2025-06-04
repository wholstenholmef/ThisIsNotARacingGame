extends Node

var map_load

func _ready() -> void:
	MusicPlayer.play_random_circuit_track()
	map_load = load(Global.preload_map)
	var map_instance = map_load.instantiate()
	call_deferred("add_child", map_instance)
