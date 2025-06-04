class_name Track
extends Node3D

signal car_lap

@export var max_laps = 3

var checkpoint_areas
var race_car_trackers = {}

var valid_checkpoints : bool = false

func _ready() -> void:
	#get_tree().get_first_node_in_group("raceCar").respawn($playerSpawnMarker.position)
	generate_racecars_array()
	connect_checkpoint_areas()

func generate_racecars_array() -> void:
	#Create all the player progress trackers
	var race_cars = get_tree().get_nodes_in_group("raceCar")
	var idx = -1
	for race_car : carNode in race_cars:
		idx += 1
		race_car_trackers[str(race_car.player_id)] = {}
		race_car_trackers[str(race_car.player_id)]["instance"] = race_car
		race_car_trackers[str(race_car.player_id)]["current_check_point"] = 0
		race_car_trackers[str(race_car.player_id)]["current_lap"] = 1
		
		race_car.respawn(%spawnSets.get_children()[idx])

func connect_checkpoint_areas() -> void:
	checkpoint_areas = %checkpointMainNode.get_children()
	if checkpoint_areas.size() < 4:
		valid_checkpoints = false
		print("Error with the checkpoint main node! track does not have enough tracks to check (min. 3)")
		return 
	valid_checkpoints = true
	#Connect all the checkpoint areas
	var area_id = 1
	for checkpoint_area in checkpoint_areas:
		if checkpoint_area is not Area3D:
			continue
		checkpoint_area.body_entered.connect(on_checkpoint_area_body_collision.bind(area_id))
		area_id += 1

func on_checkpoint_area_body_collision(body : carNode, area_id) -> void:
	if body is not carNode:
		return
	var player_id = body.player_id
	update_car_progress(player_id, area_id)

func update_car_progress(player_id, area_id) -> void:
	var current_player_tracker = race_car_trackers[str(player_id)]["current_check_point"]
	var current_player_lap = race_car_trackers[str(player_id)]["current_lap"]
	var intended_previous_area_id = area_id -1
	print("jugador " + str(player_id) + " entra a area:" + str(area_id) + ", zona previa:" + str(current_player_tracker))
	
	#Check if player in last tracker
	if current_player_tracker == checkpoint_areas.size() -1:
		if area_id == 1:
			race_car_trackers[str(player_id)]["current_check_point"] = 1
			race_car_trackers[str(player_id)]["current_lap"] += 1
			current_player_lap = race_car_trackers[str(player_id)]["current_lap"]
			on_racecar_lap(player_id, current_player_lap)
			return
	if current_player_tracker == intended_previous_area_id:
		race_car_trackers[str(player_id)]["current_check_point"] = area_id
	elif current_player_tracker == area_id:
		pass
	else:
		player_respawn(race_car_trackers[str(player_id)]["instance"])

func _on_bound_area_body_exited(body: Node3D) -> void:
	if body is carNode:
		player_respawn(body)

func player_respawn(raceCar: carNode):
	var car_id = raceCar.player_id
	var car_last_track = get_racecar_last_track_point(car_id)
	if !valid_checkpoints:
		raceCar.respawn(%spawnSets.get_children()[car_id])
	else:
		raceCar.respawn(car_last_track)

func get_racecar_last_track_point(car_id) -> Object:
	var last_check_point = race_car_trackers[str(car_id)]["current_check_point"]
	var last_check_point_instance = %checkpointMainNode.get_children()[last_check_point]
	return last_check_point_instance

func on_racecar_lap(player_id, player_lap) -> void:
	car_lap.emit(player_id, player_lap)

#func _physics_process(delta: float) -> void:
	#%checkpointTrackerLabel.text = str(race_car_trackers["1"]["current_check_point"])
