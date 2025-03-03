extends MarginContainer

@export var input_action : String
@onready var button = $TextureButton

func _on_gui_input(event: InputEvent) -> void:
	if !input_action:
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			print("pressed")
			Input.action_press(input_action)
			button.button_pressed = true
		else:
			print("released")
			Input.action_release(input_action)
			button.button_pressed = false
