extends MarginContainer

var current_player_idx = 1
signal character_selected

func _ready() -> void:
	self.hide()
	self.modulate.a = 0

func reset() -> void:
	%textureFeedbackPlayer2.hide()
	%textureFeedbackPlayer3.hide()
	%textureFeedbackPlayer4.hide()

func open(num_players = 1) -> void:
	self.show()
	reset()
	
	var tweener = create_tween()
	tweener.tween_property(self, "modulate:a", 1, 1)
	
	if num_players >= 2:
		%textureFeedbackPlayer2.show()
	if num_players >= 3:
		%textureFeedbackPlayer3.show()
	if num_players >= 4:
		%textureFeedbackPlayer4.show()

func close() -> void:
	var tweener = create_tween()
	tweener.tween_property(self, "modulate:a", 0, 0.5)
	await tweener.finished
	self.hide()

func _on_confirm_button_pressed() -> void:
	character_selected.emit()

func await_for_player_input(player_id = 1) -> void: 
	current_player_idx = player_id
	%playerCharacterLabel.text = "[center]Personaje P" + str(player_id)
	await get_tree().process_frame
	%characterSelectBael.call_deferred("grab_focus")

func _on_character_select_bael_pressed() -> void:
	get_node('%characterCameraPlayer' + str(current_player_idx)).position.x = 0
	get_node('%characterNamePlayer' + str(current_player_idx)).text = "Bael"
	Global.set('player_'+str(current_player_idx)+'_character', "Bael")
	print(Global.get('player_'+str(current_player_idx)+'_character'))

func _on_character_select_neptune_pressed() -> void:
	get_node('%characterCameraPlayer' + str(current_player_idx)).position.x = 2
	get_node('%characterNamePlayer' + str(current_player_idx)).text = "Neptune"
	Global.set('player_'+str(current_player_idx)+'_character', "Neptune")
	print(Global.get('player_'+str(current_player_idx)+'_character'))

func _on_character_select_douche_pressed() -> void:
	get_node('%characterCameraPlayer' + str(current_player_idx)).position.x = 4
	get_node('%characterNamePlayer' + str(current_player_idx)).text = "Douche"
	Global.set('player_'+str(current_player_idx)+'_character', "Douche")
	print(Global.get('player_'+str(current_player_idx)+'_character'))
