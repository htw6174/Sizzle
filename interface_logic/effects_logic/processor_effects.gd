extends Node2D
class_name ProcessorFx

@export var hide_during_processing: bool = false
@export var hide_finished_ingredient: bool = false

@export var intermediate_texture: Texture2D
@export var final_texture: Texture2D

@export var finished_ingredient: Sprite2D
@export var completion_sprite: Sprite2D
@export var processing_animation: AnimatedSprite2D
@export var audio_player: AudioStreamPlayer
@export var progress_bar: ProgressBar
@export var active_particles: CPUParticles2D
@export var passive_particles: CPUParticles2D

var timer: Timer

func _ready():
	if completion_sprite:
		completion_sprite.visible = false
	if processing_animation:
		processing_animation.visible = false
	if progress_bar:
		progress_bar.visible = false
#	if active_particles:
#		active_particles.emitting = false
	if passive_particles:
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


func _on_Tool_item_removed(item):
	pass # Replace with function body.


func _on_tool_intermediate_ingredient_produced(ingredient):
	if completion_sprite:
		completion_sprite.texture = intermediate_texture
		completion_sprite.visible = true
	finished_ingredient.visible = not hide_finished_ingredient


func _on_tool_final_ingredient_produced(ingredient):
	if completion_sprite:
		completion_sprite.texture = final_texture
		completion_sprite.visible = true
	finished_ingredient.visible = not hide_finished_ingredient


func _on_Tool_item_returned(item):
	pass # Replace with function body.
