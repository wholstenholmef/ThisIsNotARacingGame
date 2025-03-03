extends Node

func _ready() -> void:
	$playerScreen2/SubViewportContainer/SubViewport.world_3d = $playerScreen/SubViewportContainer/SubViewport
	#$playerScreen3/SubViewportContainer/SubViewport.world_3d = $playerScreen/SubViewportContainer/SubViewport
