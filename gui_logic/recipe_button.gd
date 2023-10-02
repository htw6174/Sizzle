extends Button
class_name RecipeButton

@export var recipe: ProcessStep:
	get:
		return recipe
	set(value):
		recipe = value
		_set_recipe()

@export var _name_label: Label
@export var _description_label: Label

signal recipe_selected(recipe: ProcessStep)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_recipe():
	self.icon = recipe.result.texture
	_name_label.text = recipe.result.display_name
	_description_label.text = "%d seconds" % recipe.time_to_complete

func _pressed():
	if recipe:
		recipe_selected.emit(recipe)
