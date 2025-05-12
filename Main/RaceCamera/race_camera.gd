class_name mainCamera
extends Camera3D

@export var follow_target : Node3D
@export var offset := Vector3.ZERO
var lerp_speed = 10

var default_offset : Vector3
var offset_tweener

func _ready() -> void:
	default_offset = self.position
	offset = default_offset

func _physics_process(delta: float) -> void:
	if !follow_target:
		return
	var target_pos = follow_target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
	
	if follow_target.get_parent().target != null:
		look_at(follow_target.get_parent().target.global_position, Vector3.UP)
	else:
		look_at(follow_target.global_position, Vector3.UP)

func set_offset(value : Vector3 = default_offset, duration = 0.25) -> void:
	if offset_tweener:
		offset_tweener.kill()
	offset_tweener = create_tween()
	offset_tweener.tween_property(self, "offset", value, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
