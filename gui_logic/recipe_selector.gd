extends Control
class_name RecipeSelector

@export var options_parent: Control
@export var button_scene: PackedScene

signal opened()
signal closed()
signal recipe_selected(recipe: ProcessStep)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func present_options(options: Array[ProcessStep]):
	self.visible = true
	var to_free = options_parent.get_children()
	for node in to_free:
		node.queue_free()
	for option in options:
		var new_button = button_scene.instantiate() as RecipeButton
		new_button.recipe = option
		# TODO: set shortcut to number key by index
		new_button.recipe_selected.connect(_on_recipe_selected, CONNECT_ONE_SHOT)
		options_parent.add_child(new_button)
	opened.emit()

func _on_recipe_selected(recipe: ProcessStep):
	self.visible = false
	recipe_selected.emit(recipe)
	closed.emit()
