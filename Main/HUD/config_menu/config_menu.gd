class_name ConfigMenu
extends CanvasLayer

@export var screens_array : Array[ConfigMenuCategoryScreen]
var category_buttons_array 
@export_node_path("HBoxContainer") var category_icons_container 
@export_node_path("Label") var category_label

@onready var camera = $SubViewportContainer/SubViewport/Camera2D
@onready var icon_container = $SubViewportContainer/SubViewport/footerBar/Control/MarginContainer/menuCategoryHBox

var category_button = preload("res://Main/HUD/menu_button/menu_category_button.tscn")
var config_tab_index = 0

var title_tweener

func _ready() -> void:
	#$SubViewportContainer/SubViewport.world_2d = World2D.new()
	#load_prefs()
	open()
	
	camera.position = Vector2.ZERO
	create_category_buttons()
	deselect_all_icons()

#func load_prefs() -> void:
	#user_prefs_instance = userPrefs.load_or_create()

func open() -> void:
	$AnimationPlayer.play("open_menu")

func close() -> void:
	$AnimationPlayer.play("open_menu")

func change_config_category(_index) -> void:
	deselect_all_icons()
	animate_category_text(screens_array[_index].category_name)
	camera.global_position = screens_array[_index].global_position

func create_category_buttons() -> void:
	for screen in screens_array:
		var button_instance = category_button.instantiate()
		button_instance.category_index = screens_array.find(screen)
		button_instance.set_texture(screen.category_icon)
		get_node(category_icons_container).add_child(button_instance)
		button_instance.selected.connect(change_config_category.bind(screens_array.find(screen)))

func deselect_all_icons() -> void:
	for button in icon_container.get_children():
		button.deselect()

func animate_category_text(_text) -> void:
	get_node(category_label).text = _text
	if title_tweener:
		title_tweener.kill()
	get_node(category_label).visible_ratio = 0
	title_tweener = create_tween()
	title_tweener.tween_property(get_node(category_label), "visible_ratio", 1, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
