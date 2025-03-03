class_name PauseMenu
extends Node

var is_paused := false
@export_node_path("ConfigMenu") var config_menu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_button"):
		toggle_pause()

func toggle_pause() -> void:
	if is_paused:
		close()
	else:
		open()

func open(_change_pause_state = true) -> void:
	$AnimationPlayer.play("open_menu")
	if _change_pause_state:
		get_tree().set_deferred("paused", true)
		is_paused = true


func close(_change_pause_state = true) -> void:
	$AnimationPlayer.play("close_menu")
	if _change_pause_state:
		await $AnimationPlayer.animation_finished
		get_tree().set_deferred("paused", false)
		is_paused = false
	
func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_options_button_pressed() -> void:
	if !config_menu:
		return
	close(false)
	var config_menu_node : ConfigMenu = get_node(config_menu) 
	config_menu_node.open()


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
