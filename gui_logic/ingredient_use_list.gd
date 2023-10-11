extends Control
class_name IngredientUses

@export var ingredient: Ingredient:
	get:
		return ingredient
	set(value):
		ingredient = value
		if ingredient:
			update_display()
		else:
			# TODO: any reason to clear the page on unassignment?
			pass

@export var as_output_label: Control
@export var as_component_label: Control
@export var as_output_parent: Control
@export var as_component_parent: Control
@export var in_dish_parent: Control # TODO

@export var recipe_display_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_display():
	# Clean old nodes
	var to_free = as_output_parent.get_children()
	for node in to_free:
		node.queue_free()
	to_free = as_component_parent.get_children()
	for node in to_free:
		node.queue_free()
	
	# Create how to make list
	var created_by_steps = Cookbook.get_recipes_by_result(ingredient)
	as_output_label.visible = created_by_steps.size() > 0
	for step in created_by_steps:
		var new_display = recipe_display_scene.instantiate() as RecipeDisplay
		new_display.recipe_step = step
		as_output_parent.add_child(new_display)
	
	# Create how to use list
	var usage_steps = Cookbook.get_recipes_by_component(ingredient)
	as_component_label.visible = usage_steps.size() > 0
	for step in usage_steps:
		var new_display = recipe_display_scene.instantiate() as RecipeDisplay
		new_display.recipe_step = step
		as_component_parent.add_child(new_display)
