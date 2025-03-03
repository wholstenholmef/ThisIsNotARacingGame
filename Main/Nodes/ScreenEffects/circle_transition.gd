extends Node2D

var tweener 
signal transition_finished

func _ready() -> void:
	$ColorRect.show()
	$ColorRect.material.set_shader_parameter("shader_parameter/circle_size", 0)
	fade_in()

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
