extends Node3D

var checkpoint_areas
var race_car_trackers = {}

signal car_lap

func _ready() -> void:
	checkpoint_areas = self.get_children()
	if checkpoint_areas.size() < 4:
		print("Error with the checkpoint main node! track does not have enough tracks to check (min. 3)")
		return 
	
	#Connect all the checkpoint areas
	var area_id = 0
	for checkpointArea in checkpoint_areas:
		if checkpointArea is not Area3D:
			continue
		area_id += 1
		checkpointArea.body_entered.connect(on_checkpoint_area_body_collision.bind(area_id))
	
	#Create all the player progress trackers
	var race_cars = get_tree().get_nodes_in_group("raceCar")
	for race_car : carNode in race_cars:
		race_car_trackers[str(race_car.player_id)] = {}
		race_car_trackers[str(race_car.player_id)]["instance"] = race_car
		race_car_trackers[str(race_car.player_id)]["current_check_point"] = 0

func on_checkpoint_area_body_collision(body : carNode, area_id) -> void:
	if body is not carNode:
		return
	var player_id = body.player_id
	update_player_progress(player_id, area_id)
	#print("jugador " + str(player_id) + " entro a area:" + str(area_id))


func on_racecar_lap() -> void:
	car_lap.emit()
