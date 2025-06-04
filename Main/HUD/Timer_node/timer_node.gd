extends MarginContainer

var time : float = 0
var minutes : float = 0
var seconds : float = 0
var milliseconds : float = 0

var current_race_track : Track
var current_lap = 1

@onready var lap_label_player_1 = %LapControlP1
@export_node_path("Control") var lap_label_player_2
@export_node_path("Control") var lap_label_player_3
@export_node_path("Control") var lap_label_player_4

func _ready() -> void:
	current_race_track = get_tree().get_first_node_in_group("raceTrack")
	if current_race_track:
		current_race_track.car_lap.connect(on_race_car_lap)

func _process(delta: float) -> void:
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	milliseconds = fmod(time, 1) * 100
	%MinuteLabel.text = "%02d''" % minutes
	%SecondsLabel.text = "%02d'" % seconds
	%MilisecondLabel.text = "%03d" % milliseconds
	
func on_race_car_lap(player_id, lap) -> void:
	var asigned_lap_label = get_node_or_null("LapControlP" + str(player_id))
	if asigned_lap_label == null:
		print("Lap de jugador registrada sin label de lap (timerNode)")
		return
	
	%lapLabel.text = "LAP " + str(lap)
