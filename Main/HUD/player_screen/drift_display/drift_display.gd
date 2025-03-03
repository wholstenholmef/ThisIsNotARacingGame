extends Control

@export_node_path("carNode") var target_player
@export var animation_offset : Vector2

@onready var drift_timer_label = $MarginContainer/driftTimerLabel
@onready var drift_progress_bar = $MarginContainer/driftProgressBar

var tweener
var is_drift_shown := false
var default_position :=  Vector2.ZERO
var offset_position := Vector2.ZERO

var player_small_boost_time
var player_boost_time
var player_max_boost_time
var drift_bar_tweener

func _ready() -> void:
	self.modulate.a = 0
	
	if target_player:
		target_player = get_node(target_player)
		#These times are relative to the previous drift state
		#Meaning, the player boost time would be 0.8 if the player_boost_time was 1.8 and small_boost_time was 1.0
		#We need this to animate the drift progress bar tweener
		player_small_boost_time = target_player.small_boost_time
		player_boost_time = target_player.boost_time - player_small_boost_time
		player_max_boost_time = target_player.super_boost_time - player_boost_time - player_small_boost_time
	
	await get_tree().create_timer(0.1).timeout
	default_position = self.position
	offset_position = default_position + animation_offset
	self.global_position = offset_position

func _process(delta: float) -> void:
	if !target_player:
		return
		
	if target_player.drift_time != 0:
		if !is_drift_shown:
			if tweener:
				tweener.kill()
			self.position = offset_position
			self.modulate.a = 0
			tweener = create_tween().set_parallel()
			tweener.tween_property(self, "position", default_position, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			tweener.tween_property(self, "modulate:a", 1, 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			animate_drift_bar()
			is_drift_shown = true
		var drift_seconds = fmod(target_player.drift_time, 60)
		var drift_mseconds = fmod(target_player.drift_time, 1) * 100 
		drift_timer_label.text = "%02d.%02d" % [drift_seconds, drift_mseconds]
	else:
		if is_drift_shown:
			if tweener:
				tweener.kill()
			tweener = create_tween().set_parallel()
			tweener.tween_property(self, "position", offset_position, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			tweener.tween_property(self, "modulate:a", 0, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			is_drift_shown = false
			if drift_bar_tweener:
				drift_bar_tweener.kill()
			drift_bar_tweener = create_tween()
			drift_bar_tweener.tween_property(drift_progress_bar, "value", 0, 0.2)

func animate_drift_bar() -> void:
	drift_progress_bar.set_deferred("value", 0)
	if drift_bar_tweener:
		drift_bar_tweener.kill()
	drift_bar_tweener = create_tween()
	drift_bar_tweener.tween_property(drift_progress_bar, "value", 100, player_small_boost_time)
	drift_bar_tweener.tween_property(drift_progress_bar, "value", 0, 0.05).set_ease(Tween.EASE_OUT)
	drift_bar_tweener.tween_property(drift_progress_bar, "value", 100, player_boost_time)
	drift_bar_tweener.tween_property(drift_progress_bar, "value", 0, 0.05)
	drift_bar_tweener.tween_property(drift_progress_bar, "value", 100, player_max_boost_time)
