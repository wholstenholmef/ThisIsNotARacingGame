extends Control

var state
enum MACHINE{
	INTRO,
	TITLE_SCREEN,
	GAME_SELECT
}

var cursor_tweener

@onready var main = preload("res://Main/Main.tscn")
@onready var main_two_players = preload("res://Main/main_two_players.tscn")
@onready var main_three_players = preload("res://Main/main_three_players.tscn")
@onready var main_four_players = preload("res://Main/main_four_players.tscn")

func _ready() -> void:
	get_tree().call_deferred("set_pause", false)
	state = MACHINE.INTRO
	$AnimationPlayer.call_deferred("play", "intro")
	connect_all_buttons()

func connect_all_buttons() -> void:
	var buttons = get_tree().get_nodes_in_group("menu_button")
	for button:Control in buttons:
		button.focus_entered.connect(on_button_focus_entered.bind(button))

func _process(delta: float) -> void:
	match state:
		MACHINE.TITLE_SCREEN:
			if Input.is_anything_pressed():
				state = MACHINE.GAME_SELECT
				$AnimationPlayer.play("menu_backdrop")
		MACHINE.GAME_SELECT:
			pass

func on_button_focus_entered(instance) -> void:
	var calculate_center = Vector2(instance.size.x/2, instance.size.y/2)
	var calculated_position = instance.global_position + calculate_center
	if cursor_tweener:
		cursor_tweener.kill()
	cursor_tweener = create_tween()
	cursor_tweener.tween_property(%pointer, "position",calculated_position, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func play_explosion_sfx() -> void:
	%explosionSFX.pitch_scale = randf_range(0.8, 1.25)
	%explosionSFX.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"intro":
			MusicPlayer.play_OST("no_games")
			state = MACHINE.TITLE_SCREEN
		"menu_backdrop":
			%onePlayerGame.grab_focus()

func _on_one_player_game_pressed() -> void:
	%gameSelectAnimationPlayer.play("fade")
	await %gameSelectAnimationPlayer.animation_finished
	%characterSelectionMargin.open()
	%characterSelectionMargin.await_for_player_input(1)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.close()
	%trackSelectionMenu.open()
	await %trackSelectionMenu.map_chosen
	%circleTransition.fade_in()
	await %circleTransition.transition_finished
	get_tree().change_scene_to_packed(main)

func _on_two_player_game_pressed() -> void:
	%gameSelectAnimationPlayer.play("fade")
	await %gameSelectAnimationPlayer.animation_finished
	%characterSelectionMargin.open(2)
	%characterSelectionMargin.await_for_player_input(1)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.await_for_player_input(2)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.close()
	%trackSelectionMenu.open()
	await %trackSelectionMenu.map_chosen
	%circleTransition.fade_in()
	await %circleTransition.transition_finished
	get_tree().change_scene_to_packed(main_two_players)

func _on_three_player_game_pressed() -> void:
	%gameSelectAnimationPlayer.play("fade")
	await %gameSelectAnimationPlayer.animation_finished
	%characterSelectionMargin.open(3)
	%characterSelectionMargin.await_for_player_input(1)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.await_for_player_input(2)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.await_for_player_input(3)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.close()
	%trackSelectionMenu.open()
	await %trackSelectionMenu.map_chosen
	%circleTransition.fade_in()
	await %circleTransition.transition_finished
	get_tree().change_scene_to_packed(main_three_players)

func _on_four_player_game_pressed() -> void:
	%gameSelectAnimationPlayer.play("fade")
	await %gameSelectAnimationPlayer.animation_finished
	%characterSelectionMargin.open(3)
	%characterSelectionMargin.await_for_player_input(1)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.await_for_player_input(2)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.await_for_player_input(3)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.await_for_player_input(4)
	await %characterSelectionMargin.character_selected
	%characterSelectionMargin.close()
	%trackSelectionMenu.open()
	await %trackSelectionMenu.map_chosen
	%circleTransition.fade_in()
	await %circleTransition.transition_finished
	get_tree().change_scene_to_packed(main_four_players)
