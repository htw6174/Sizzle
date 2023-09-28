extends Node

var ingredients_directory: String = "res://custom_resources/ingredients/"
var process_scene: PackedScene = preload("res://gameplay_logic/process_definitions.tscn")
var processes: Node

var ingredients: Array[Ingredient]

var recipes: Dictionary # Key: result, Value: array of components?

# Called when the node enters the scene tree for the first time.
func _ready():
	processes = process_scene.instantiate()
	load_resources(ingredients_directory, Ingredient, ingredients)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_resources(directory: String, type: Variant, dest: Array):
	var dir = DirAccess.open(directory)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var res = load(directory + file_name)
			if res != null:
				if is_instance_of(res, type):
					dest.append(res)
		file_name = dir.get_next()

func get_recipes_by_component(component_ingredient: Ingredient) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep] = []
	var tools = processes.get_children()
	for tool in tools:
		var steps = tool.get_children()
		for step in steps:
			if step is ProcessStep:
				if step.ingredients.has(component_ingredient):
					recipes.append(step)
	return recipes

func get_recipes_by_result(result_ingredient: Ingredient) -> Array[ProcessStep]:
	var recipes: Array[ProcessStep] = []
	var tools = processes.get_children()
	for tool in tools:
		var steps = tool.get_children()
		for step in steps:
			if step is ProcessStep:
				var results = step.get_children()
				for result in results:
					if result is ProcessResult:
						if result.ingredient == result_ingredient:
							recipes.append(step)
	return recipes

func get_recipes_by_tool() -> Array[ProcessStep]:
	# TODO: don't have a type for tools yet, need one to set this up
	return []
