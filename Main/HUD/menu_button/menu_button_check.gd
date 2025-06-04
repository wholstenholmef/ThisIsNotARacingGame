extends "res://Main/HUD/menu_button/menu_button.gd"

var color_tweener

func _on_toggled(toggled_on: bool) -> void:
	button_pressed = toggled_on
	%CheckBox.button_pressed = toggled_on
	if toggled_on:
		animate_label_color(Color.BLACK)
	else:
		animate_label_color(Color.WHITE)

func animate_label_color(_color : Color = Color.WHITE) -> void:
	if color_tweener:
		color_tweener.kill()
	color_tweener = create_tween()
	color_tweener.tween_property(self, "theme_override_colors/font_color", _color, 0.4)
