extends Node

export(NodePath) var serving_dish_parent_path
onready var serving_dish_parent: Node2D = get_node(serving_dish_parent_path)
export(PackedScene) var serving_dish_scene: PackedScene
export(Array, Resource) var objective_dishes

var objective_index: int = 0
var current_dish: Interactable = null

func _ready():
	begin_next_objective()

func begin_next_objective():
	# instantiate serving dish
	var new_dish = serving_dish_scene.instance()
	serving_dish_parent.add_child(new_dish)
	new_dish.set_owner(serving_dish_parent)
	# set serving dish properties
	assert(new_dish is Interactable)
	new_dish.target_dish = objective_dishes[objective_index]
	# connect to dish complete signal
	new_dish.connect("dish_complete", self, "_on_ServingDish_dish_complete")
	# push dish into frame
	current_dish = new_dish
	# update objective tracker text
	pass

func complete_objective():
	# short delay
	# show new dish created animation
	# pull dish out of frame
	# remove instance
	pass

func _on_ServingDish_dish_complete(dish: Dish):
	complete_objective()
	objective_index += 1
	begin_next_objective()
