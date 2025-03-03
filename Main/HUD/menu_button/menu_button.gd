@tool
extends MarginContainer

signal pressed
@export_multiline var button_text : String
var tweener

func _ready() -> void:
	$contentMargin/Label.text = button_text
	self.pivot_offset.y = self.size.y / 2

func _on_menu_button_pressed() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property(self, "scale:y", 0.5, 0.05).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tweener.tween_property(self, "scale:y", 1, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$clickSFX.pitch_scale = randf_range(0.9, 1.2)
	$clickSFX.play()
	pressed.emit()
