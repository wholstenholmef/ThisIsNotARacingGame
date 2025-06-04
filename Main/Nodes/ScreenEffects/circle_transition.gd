extends Control

@export var fade_in_on_startup : bool = true

var tweener 
signal transition_finished

func _ready() -> void:
	$ColorRect.show()
	$ColorRect.material.set_shader_parameter("material:shader_parameter/circle_size", 1.05)
	if fade_in_on_startup:
		fade_in()
	$ColorRect.set_deferred("material:shader_parameter/screen_width", get_viewport().size.x)
	$ColorRect.set_deferred("material:shader_parameter/screen_width", get_viewport().size.y)

func fade_in() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween()
	tweener.tween_property($ColorRect, "material:shader_parameter/circle_size", 1.05, 0.7).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	await tweener.finished
	transition_finished.emit()

func fade_out() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween().set_parallel()
	tweener.tween_property($ColorRect, "material:shader_parameter/circle_size", 0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tweener.finished
	transition_finished.emit()
