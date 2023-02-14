extends Node

export(bool) var hide_during_processing: bool = false
export(bool) var hide_finished_ingredient: bool = false
export(NodePath) var finished_ingredient_path
onready var finished_ingredient: Sprite = get_node(finished_ingredient_path)
export(NodePath) var completion_sprite_path
var completion_sprite: Sprite
export(NodePath) var processing_animation_path
var processing_animation: AnimatedSprite
export(NodePath) var audio_player_path
onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)
export(NodePath) var progress_bar_path
onready var progress_bar: ProgressBar = get_node(progress_bar_path)
export(NodePath) var active_active_particles_path
var active_particles: CPUParticles2D
export(NodePath) var passive_particles_path
var passive_particles: CPUParticles2D

var timer: Timer

func _ready():
	if completion_sprite_path != "":
		completion_sprite = get_node(completion_sprite_path)
		completion_sprite.visible = false
	if processing_animation_path != "":
		processing_animation = get_node(processing_animation_path)
		processing_animation.visible = false
		progress_bar.visible = false
	if active_active_particles_path != "":
		active_particles = get_node(active_active_particles_path)
		active_particles.emitting = false
	if passive_particles_path != "":
		passive_particles = get_node(passive_particles_path)
		passive_particles.emitting = true

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
	finished_ingredient.visible = not hide_during_processing


func _on_Tool_process_finished():
	audio_player.stop()


func _on_Tool_process_step_started():
	if processing_animation:
		processing_animation.visible = true
		processing_animation.play()
	if active_particles:
		active_particles.emitting = true
	if passive_particles:
		passive_particles.emitting = false


func _on_Tool_process_step_finished():
	if processing_animation:
		processing_animation.visible = false
		processing_animation.stop()
	if active_particles:
		active_particles.emitting = false
	if passive_particles:
		passive_particles.emitting = true


func _on_Tool_process_step_changed(process_step):
	pass # Replace with function body.


func _on_Tool_item_inserted(item):
	pass # Replace with function body.


func _on_Tool_item_reserved(item):
	if completion_sprite:
		completion_sprite.visible = false


func _on_Tool_item_removed():
	pass # Replace with function body.


func _on_Tool_result_ingredient_produced(ingredient):
	if completion_sprite:
		completion_sprite.visible = true
	finished_ingredient.visible = not hide_finished_ingredient
