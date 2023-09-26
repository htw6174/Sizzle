extends Control
class_name RecipeBook

@export var ingredient_list: Control
@export var ingredient_detail: IngredientDescription

# Note: to avoid layout issues (and because I'm using ScrollContainers for these nodes), should enforce only 1 child node for these
@export var left_page: Control
@export var right_page: Control

@export var hidden_page: Control

signal opened()
signal closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	open_ingredient_index()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: need to find a solution other than reparenting constantly, very error-prone
func open_ingredient_index():
	hidden_page.remove_child(ingredient_list)
	left_page.add_child(ingredient_list)
	opened.emit()

func open_ingredient_details(ingredient: Ingredient):
	hidden_page.remove_child(ingredient_detail)
	right_page.add_child(ingredient_detail)
	ingredient_detail.ingredient = ingredient
	opened.emit()

func close_ingredient_details():
	right_page.remove_child(ingredient_detail)
	hidden_page.add_child(ingredient_detail)

func _on_close_pressed():
	self.visible = false
	closed.emit()
