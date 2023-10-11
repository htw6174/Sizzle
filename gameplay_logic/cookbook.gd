extends Node

enum ToolTypes {
	Skillet,
	Grill,
	Pot,
	CuttingBoard,
	Combine,
	Cauldron
}

var ingredients_directory: String = "res://custom_resources/ingredients/"
var process_scene: PackedScene = preload("res://gameplay_logic/process_definitions.tscn")
var _processes: Node

var ingredients: Array[Ingredient]
var tools: Array[ProcessingTool]

# TODO: once recipe def is more solid, consider creating structure for fast lookup
# Probably only needed when total number of recipes is in the thousands

func _ready():
	_processes = process_scene.instantiate()
	self.add_child(_processes)
	#load_resources(ingredients_directory, Ingredient, ingredients)
	_scrape_ingredients(_processes)
	_sort_ingredients()

# Only works when running from editor, need better general solution
#func load_resources(directory: String, type: Variant, dest: Array):
#	var dir = DirAccess.open(directory)
#	dir.list_dir_begin()
#	var file_name = dir.get_next()
#	while file_name != "":
#		if !dir.current_is_dir():
#			var res = load(directory + file_name)
#			if res != null:
#				if is_instance_of(res, type):
#					dest.append(res)
#		file_name = dir.get_next()

func _scrape_ingredients(node: Node):
	var children = node.get_children()
	for child in children:
		if child is ProcessStep:
			for component in child.ingredients:
				if !ingredients.has(component):
					ingredients.append(component)
			# quick hack to prevent optional results from showing up
			if !ingredients.has(child.result) and !(child.get_parent() is ProcessStep):
				ingredients.append(child.result)
		if child is ProcessingTool:
			if !tools.has(child):
				tools.append(child)
		_scrape_ingredients(child)

func _ingredient_compare_alphabetical(a: Ingredient, b: Ingredient) -> bool:
	return a.display_name.naturalnocasecmp_to(b.display_name) < 0

func _sort_ingredients():
	ingredients.sort_custom(_ingredient_compare_alphabetical)

func get_tool_by_type(type: ToolTypes) -> ProcessingTool:
	var tools = _processes.get_children()
	for tool in tools:
		if tool is ProcessingTool:
			if tool.tool_type == type:
				return tool
	assert(false, "No processing tool with type '%s'" % type)
	return null

func get_recipes(tool: ProcessingTool, ingredient: Ingredient) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep]
	var steps = tool.get_children()
	for step in steps:
		if step is ProcessStep:
			if step.ingredients.has(ingredient):
				recipes.append(step)
	return recipes

func does_ingredient_have_recipe(tool: ProcessingTool, ingredient: Ingredient) -> bool:
	var recipes = tool.get_children()
	for recipe in recipes:
		if recipe is ProcessStep:
			if recipe.ingredients.has(ingredient):
				return true
	return false

func does_list_have_recipe(tool: ProcessingTool, ingredients: Array[Ingredient]) -> bool:
	var recipes = tool.get_children()
	for recipe in recipes:
		if recipe is ProcessStep:
			# check that all items in ingredients have a match in recipe.ingredients
			var temp_reqs = recipe.ingredients.duplicate()
			var is_match = true
			for ingredient in ingredients:
				if temp_reqs.has(ingredient):
					temp_reqs.erase(ingredient)
				else:
					is_match = false
			if is_match: return true
	return false

func does_step_have_optionals(step: ProcessStep) -> bool:
	var children = step.get_children()
	for child in children:
		# TODO: should make a new node type for optionals, allow setting categories of ingredient
		if child is ProcessStep: 
			return true
	return false

func is_ingredient_valid_optional(step: ProcessStep, ingredient: Ingredient) -> bool:
	var children = step.get_children()
	for child in children:
		if child is ProcessStep:
			if child.ingredients.has(ingredient):
				return true
	return false

func get_optional_step_by_ingredient(current_step: ProcessStep, ingredient: Ingredient) -> ProcessStep:
	var children = current_step.get_children()
	for child in children:
		if child is ProcessStep:
			if child.ingredients.has(ingredient):
				return child as ProcessStep
	return null

func get_combos(tool: ProcessingTool, item1: Ingredient, item2: Ingredient) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep] = []
	var combos = tool.get_children()
	for combo in combos:
		if combo is ProcessStep:
			if (combo.ingredients[0] == item1 && combo.ingredients[1] == item2) || (combo.ingredients[0] == item2 && combo.ingredients[1] == item1):
				recipes.append(combo)
	return recipes

func get_recipes_by_component(component_ingredient: Ingredient) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep] = []
	var tools = _processes.get_children()
	for tool in tools:
		var steps = tool.get_children()
		for step in steps:
			if step is ProcessStep:
				if step.ingredients.has(component_ingredient):
					recipes.append(step)
#				if is_ingredient_valid_optional(step, component_ingredient):
#					recipes.append(step)
	return recipes

func get_recipes_by_result(result_ingredient: Ingredient) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep] = []
	var tools = _processes.get_children()
	for tool in tools:
		var steps = tool.get_children()
		for step in steps:
			if step is ProcessStep:
				if step.result == result_ingredient:
					recipes.append(step)
	return recipes

func get_recipes_by_tool(tool: ProcessingTool) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep] = []
	var steps = tool.get_children()
	for step in steps:
		if step is ProcessStep:
			recipes.append(step)
	return []
