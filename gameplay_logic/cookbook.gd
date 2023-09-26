extends Node

var ingredients_directory: String = "res://custom_resources/ingredients/"

var ingredients: Array[Ingredient]

# Called when the node enters the scene tree for the first time.
func _ready():
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
