extends Node3D

@export_node_path("Node2D") var screen_transition_node

func _ready() -> void:
	if screen_transition_node:
		screen_transition_node = get_node(screen_transition_node)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is carNode:
		if screen_transition_node:
			screen_transition_node.fade_out()
			await screen_transition_node.transition_finished
			screen_transition_node.fade_in()
		body.respawn($playerSpawnMarker.position)
