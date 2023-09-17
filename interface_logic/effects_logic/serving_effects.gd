extends Node2D

class_name ServingEffects

@export var animation_player: AnimationPlayer

signal dish_begin_effects_finished
signal dish_complete_effects_finished

func serve():
	animation_player.play("dish_exit")

func new_dish():
	animation_player.play("dish_enter")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "dish_enter":
		dish_begin_effects_finished.emit()
	elif anim_name == "dish_exit":
		dish_complete_effects_finished.emit()
