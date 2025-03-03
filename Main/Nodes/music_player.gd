extends AudioStreamPlayer

var race_theme = preload("res://Assets/OST/estrenandoremix.wav")

func _ready() -> void:
	self.stream = race_theme
	#self.play()
