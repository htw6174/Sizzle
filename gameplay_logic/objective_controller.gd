extends Node

class_name ObjectiveController

@export var dialogue_player: DialoguePlayer
@export var objective_label: Label
@export var end_screen: Control 
@export var serving_dish_parent: ServingEffects
@export var serving_dish_scene: PackedScene
@export var missions: Array[Mission]

var dish_index: int = 0
var mission_index: int = 0
var current_dish: Interactable = null

signal objective_complete
signal begin_objective

func _ready():
	dialogue_player.connect("ready", Callable(self, "_on_DialoguePlayer_ready"))
	dialogue_player.connect("dialogue_finished", Callable(self, "_on_DialoguePlayer_dialogue_finished"))
	serving_dish_parent.connect("ready", Callable(self, "_on_ServingEffects_ready"))
	serving_dish_parent.connect("dish_begin_effects_finished", Callable(self, "_on_ServingEffects_dish_begin_effects_finished"))
	serving_dish_parent.connect("dish_complete_effects_finished", Callable(self, "_on_ServingEffects_dish_complete_effects_finished"))
	self.connect("begin_objective", Callable(serving_dish_parent, "_on_ObjectiveController_begin_objective"))
	self.connect("objective_complete", Callable(serving_dish_parent, "_on_ObjectiveController_objective_complete"))

func begin_next_mission():
	if mission_index >= missions.size():
		# handle game ending
		end_screen.visible = true
	else:
		dish_index = 0
		dialogue_player.start_dialogue(missions[mission_index].start_dialogue)

func begin_next_dish():
	# instantiate serving dish
	var target_dish = missions[mission_index].dishes[dish_index]
	var new_dish_scene = target_dish.serving_dish_scene.instantiate()
	# set serving dish properties
	assert(new_dish_scene is Interactable)
	# TODO: might need to do something like this for tutorial dish step scenes
	#new_dish_scene.target_dish = target_dish
	# add to scene
	serving_dish_parent.add_child(new_dish_scene)
	new_dish_scene.set_owner(serving_dish_parent)
	# connect to dish complete signal
	new_dish_scene.connect("dish_complete", Callable(self, "_on_ServingDish_dish_complete"))
	# push dish into frame
	emit_signal("begin_objective")
	# update objective tracker text
	objective_label.text = target_dish.description
	current_dish = new_dish_scene

func _on_ServingDish_dish_complete(dish_step: DishStep):
	objective_label.text = ""
	objective_label.get_parent().visible = false # FIXME horrible shortcut
	emit_signal("objective_complete")

func _on_DialoguePlayer_ready():
	begin_next_mission()

func _on_DialoguePlayer_dialogue_finished():
	begin_next_dish()

func _on_ServingEffects_ready():
	#begin_next_mission()
	pass

func _on_ServingEffects_dish_begin_effects_finished():
	#objective_label.get_parent().visible = true # FIXME horrible shortcut
	pass

func _on_ServingEffects_dish_complete_effects_finished():
	# remove instance
	current_dish.queue_free()
	dish_index += 1
	if dish_index >= missions[mission_index].dishes.size():
		mission_index += 1
		begin_next_mission()
	else:
		begin_next_dish()

func reset_progress():
	end_screen.visible = false
	mission_index = 0
	begin_next_mission()


func _on_RestartButton_pressed():
	reset_progress()


func _on_bell_rung():
	current_dish.serve()
