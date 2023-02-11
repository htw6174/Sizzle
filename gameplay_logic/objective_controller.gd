extends Node

class_name ObjectiveController

export(NodePath) var objective_label_path
onready var objective_label: Label = get_node(objective_label_path)
export(NodePath) var serving_dish_parent_path
onready var serving_dish_parent: ServingEffects = get_node(serving_dish_parent_path)
export(PackedScene) var serving_dish_scene: PackedScene
export(Array, Resource) var objective_dishes

var objective_index: int = 0
var current_dish: Interactable = null

signal objective_complete
signal begin_objective

func _ready():
	serving_dish_parent.connect("ready", self, "_on_ServingEffects_ready")
	serving_dish_parent.connect("dish_begin_effects_finished", self, "_on_ServingEffects_dish_begin_effects_finished")
	serving_dish_parent.connect("dish_complete_effects_finished", self, "_on_ServingEffects_dish_complete_effects_finished")
	self.connect("begin_objective", serving_dish_parent, "_on_ObjectiveController_begin_objective")
	self.connect("objective_complete", serving_dish_parent, "_on_ObjectiveController_objective_complete")

func begin_next_objective():
	# instantiate serving dish
	var new_dish = serving_dish_scene.instance()
	# set serving dish properties
	assert(new_dish is Interactable)
	new_dish.target_dish = objective_dishes[objective_index]
	# add to scene
	serving_dish_parent.add_child(new_dish)
	new_dish.set_owner(serving_dish_parent)
	# connect to dish complete signal
	new_dish.connect("dish_complete", self, "_on_ServingDish_dish_complete")
	# push dish into frame
	emit_signal("begin_objective")
	# update objective tracker text
	objective_label.text = new_dish.target_dish.description
	current_dish = new_dish
	pass

func _on_ServingDish_dish_complete(dish: Dish):
	objective_label.text = ""
	objective_label.get_parent().visible = false # FIXME horrible shortcut
	emit_signal("objective_complete")

func _on_ServingEffects_ready():
	begin_next_objective()

func _on_ServingEffects_dish_begin_effects_finished():
	objective_label.get_parent().visible = true # FIXME horrible shortcut
	pass

func _on_ServingEffects_dish_complete_effects_finished():
	# remove instance
	current_dish.queue_free()
	# go to victory screen or next objective
	if objective_index >= objective_dishes.size() - 1:
		# TODO: handle game ending
		print("Victory!")
	else:
		objective_index += 1
		begin_next_objective()
