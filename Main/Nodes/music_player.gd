extends AudioStreamPlayer

#var no_games = preload("res://Assets/OST/no_games.mp3")
#var estrenando_remix = preload("res://Assets/OST/estrenandoremix.wav")
#var hemp_wraps = preload("res://Assets/OST/HempWraps.mp3")
#var idk = preload("res://Assets/OST/IDK.mp3")
#var layin_low = preload("res://Assets/OST/layin_low.mp3")
#var starlight_in_the_night = preload("res://Assets/OST/starlight_in_the_night.mp3")
#var true_zero = preload("res://Assets/OST/true_zero.mp3")

#var track_list = {
	#"no_games" = {
		#stream = "res://Assets/OST/no_games.mp3",
		#autor = "Juan Basto"
	#}
	#"estrenando_remix" = {
		#stream = "res://Assets/OST/no_games.mp3",
		#autor = "Juan Basto"
	#}
#}

var circuit_tracks = [
	"estrenando_remix",
	"hemp_wraps",
	"idk",
	"layin_low",
	"starlight_in_the_night",
	"true_zero"
]

func play_OST(ost_name) -> void:
	match ost_name:
		"no_games":
			%songTitle.text = "NO GAMES"
			%songCredit.text = "Juan Basto"
			stream = load("res://Assets/OST/no_games.mp3")
		"estrenando_remix":
			%songTitle.text = "Estrenando (remix)"
			%songCredit.text = "Mafra"
			stream = load("res://Assets/OST/estrenandoremix.wav")
		"hemp_wraps":
			%songTitle.text = "Hemp Wraps"
			%songCredit.text = "Nintenaya"
			stream = load("res://Assets/OST/HempWraps.mp3")
		"idk":
			%songTitle.text = "IDK!"
			%songCredit.text = "Nintenaya"
			stream = load("res://Assets/OST/IDK.mp3")
		"layin_low":
			%songTitle.text = "Layin' low"
			%songCredit.text = "Nintenaya"
			stream = load("res://Assets/OST/layin_low.mp3")
		"starlight_in_the_night":
			%songTitle.text = "Strlght in the night"
			%songCredit.text = "Nintenaya"
			stream = load("res://Assets/OST/starlight_in_the_night.mp3")
		"true_zero":
			%songTitle.text = "True Zer0"
			%songCredit.text = "Nintenaya"
			stream = load("res://Assets/OST/true_zero.mp3")
	$AnimationPlayer.play("track_play")
	self.play()

func play_random_circuit_track() -> void:
	play_OST(circuit_tracks.pick_random())
