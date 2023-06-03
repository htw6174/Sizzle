extends Node

class_name ServingEffects

@export var animation_player_path: NodePath
@onready var animation_player: AnimationPlayer = get_node(animation_player_path)

signal dish_begin_effects_finished
signal dish_complete_effects_finished

func _on_ObjectiveController_begin_objective():
	animation_player.play("dish_enter")

func _on_ObjectiveController_objective_complete():
	# TODO: show new dish created animation
	animation_player.play("dish_exit")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dish_enter":
		emit_signal("dish_begin_effects_finished")
	elif anim_name == "dish_exit":
		emit_signal("dish_complete_effects_finished")
