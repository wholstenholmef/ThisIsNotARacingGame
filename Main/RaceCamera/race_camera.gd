class_name mainCamera
extends Camera3D

@export var follow_target : Node3D
var default_offset := Vector3.ZERO
var offset := Vector3.ZERO
@export var lerp_speed = 10
var offset_tweener

func _ready() -> void:
	#await get_tree().process_frame
	#I dont know why we have to flip these??
	default_offset.y = self.position.z
	default_offset.z = self.position.y
	offset = default_offset

func _physics_process(delta: float) -> void:
	if !follow_target:
		return
	var target_pos = follow_target.global_transform.translated_local(offset)
	#var target_pos = follow_target.global_transform.origin + offset
	
	#global_transform.origin = global_transform.origin.lerp(target_pos, lerp_speed * delta)
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
	look_at(follow_target.global_position, Vector3.UP)

func set_offset(value : Vector3 = default_offset, duration = 0.25) -> void:
	if offset_tweener:
		offset_tweener.kill()
	offset_tweener = create_tween()
	offset_tweener.tween_property(self, "offset", value, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
