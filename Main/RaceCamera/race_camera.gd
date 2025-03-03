extends Camera3D

@export var follow_target : Node3D
var offset := Vector3.ZERO
var lerp_speed = 10

func _ready() -> void:
	offset = self.position

func _physics_process(delta: float) -> void:
	if !follow_target:
		return
	var target_pos = follow_target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
	
	if follow_target.get_parent().target != null:
		look_at(follow_target.get_parent().target.global_position, Vector3.UP)
	else:
		look_at(follow_target.global_position, Vector3.UP)
