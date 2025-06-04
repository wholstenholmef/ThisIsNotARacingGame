extends Node3D

@export var spinning := false
@export var sitting := true
@export var spinning_speed := 1

var rotation_tween
var model

func _ready() -> void:
	model = self.get_child(0)
	if sitting:
		var animation = model.get_node_or_null("AnimationPlayer")
		if !animation:
			animation.play("Throttle")

func _physics_process(delta: float) -> void:
	if !model:
		return
	if spinning:
		model.rotation_degrees.y += spinning_speed

func tween_rotation(value = 0) -> void:
	spinning = false
	if rotation_tween:
		rotation_tween.kill()
	rotation_tween = create_tween()
	rotation_tween.tween_property(self, "rotation_degrees:y", value, 0.7).set_ease(Tween.EASE_OUT).set_trans(quaternion)
