extends Control

var tweener 

func _ready() -> void:
	$barUpper.scale.y = 0
	$barDown.scale.y = 0

func focus_in() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween().set_parallel()
	tweener.tween_property($barUpper, "scale:y", 1, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tweener.tween_property($barDown, "scale:y", 1, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func focus_out() -> void:
	if tweener:
		tweener.kill()
	tweener = create_tween().set_parallel()
	tweener.tween_property($barUpper, "scale:y", 0, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tweener.tween_property($barDown, "scale:y", 0, 0.2).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
