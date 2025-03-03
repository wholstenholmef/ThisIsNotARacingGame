extends MarginContainer

var time : float = 0
var minutes : float = 0
var seconds : float = 0
var milliseconds : float = 0

@onready var minute_label = $CenterContainer/HBoxContainer/MinuteLabel
@onready var second_label = $CenterContainer/HBoxContainer/SecondsLabel
@onready var millisecond_label = $CenterContainer/HBoxContainer/MilisecondLabel

func _process(delta: float) -> void:
	time += delta
	minutes = fmod(time, 3600) / 60
	seconds = fmod(time, 60)
	milliseconds = fmod(time, 1) * 100
	minute_label.text = "%02d''" % minutes
	second_label.text = "%02d'" % seconds
	millisecond_label.text = "%03d" % milliseconds
