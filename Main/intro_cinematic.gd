extends Control

var main_menu = preload("res://Main/Menus/mainMenu.tscn")

func _physics_process(delta: float) -> void:
	if Input.is_anything_pressed():
		on_finish()

func _on_video_stream_player_finished() -> void:
	on_finish()

func on_finish() -> void:
	get_tree().change_scene_to_packed(main_menu)
