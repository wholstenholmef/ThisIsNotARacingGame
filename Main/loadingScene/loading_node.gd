extends Node3D

var main_scene = preload("res://Main/introCinematic.tscn")

func _on_timer_timeout() -> void:
	get_tree().call_deferred("change_scene_to_packed", main_scene)
