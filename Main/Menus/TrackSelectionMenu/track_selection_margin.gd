extends Control

signal map_chosen

func _ready() -> void:
	hide()
	self.modulate.a = 0

func open() -> void:
	show()
	var tweener = create_tween()
	tweener.tween_property(self, "modulate:a", 1, 1)
	await get_tree().process_frame
	%desert.call_deferred("grab_focus")
	_on_desert_pressed()
	
func _on_swamp_pressed() -> void:
	%mapLabel.text = "[center][shake]Pantano mistico"
	Global.preload_map = "res://Tracks/MagicSwamp/magicSwamp.tscn"

func _on_desert_pressed() -> void:
	%mapLabel.text = "[center][wave]Desierto flurbiano"
	Global.preload_map = "res://Tracks/Desert/martianDesert.tscn"

func _on_interspace_pressed() -> void:
	%mapLabel.text = "[center][rainbow]Interespacial 8"
	Global.preload_map = "res://Tracks/Interspace8/track_interspace8.tscn"

func _on_confirm_button_pressed() -> void:
	map_chosen.emit()
