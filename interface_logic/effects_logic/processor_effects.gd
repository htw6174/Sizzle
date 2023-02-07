extends Node

export(NodePath) var processing_animation_path
onready var processing_animation: AnimatedSprite = get_node(processing_animation_path)
export(NodePath) var audio_player_path
onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)
export(NodePath) var progress_bar_path
onready var progress_bar: ProgressBar = get_node(progress_bar_path)

var timer: Timer

func _ready():
	processing_animation.visible = false
	progress_bar.visible = false

func _process(delta):
	if timer:
		if timer.is_stopped():
			progress_bar.visible = false
		else:
			progress_bar.visible = true
			var timer_progress = 1.0 - (timer.time_left / timer.wait_time)
			progress_bar.value = timer_progress





func _on_Tool_process_started():
	audio_player.play()


func _on_Tool_process_finished():
	audio_player.stop()


func _on_Tool_process_step_started():
	processing_animation.visible = true
	processing_animation.play()


func _on_Tool_process_step_finished():
	processing_animation.visible = false
	processing_animation.stop()


func _on_Tool_process_step_changed(process_step):
	pass # Replace with function body.


func _on_Tool_ingredient_added(ingredient):
	pass # Replace with function body.


func _on_Tool_ingredient_removed():
	pass # Replace with function body.


func _on_Tool_result_ingredient_produced(ingredient):
	pass # Replace with function body.
