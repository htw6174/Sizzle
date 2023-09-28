extends Control
class_name RecipeBook

@export var ingredient_list: Control
@export var ingredient_detail: IngredientDescription
@export var ingredient_uses: IngredientUses

@export var index_tab_bar: TabBar
@export var left_page: TabContainer
@export var right_page: TabContainer

signal opened()
signal closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	open_ingredient_index()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open_ingredient_index():
	left_page.current_tab = 0
	right_page.current_tab = 0
	opened.emit()

func open_dish_index():
	opened.emit()

func open_tool_index():
	opened.emit()

func open_ingredient_details(ingredient: Ingredient):
	if ingredient:
		left_page.current_tab = 1
		right_page.current_tab = 1
		ingredient_detail.ingredient = ingredient
		ingredient_uses.ingredient = ingredient
		opened.emit()
	else:
		# TODO: not found page?
		pass

func _on_close_pressed():
	self.visible = false
	closed.emit()

func _on_tab_selected(tab: int):
	match (tab):
		0:
			open_ingredient_index()
		1:
			open_dish_index()
		2:
			open_tool_index()
		_:
			assert(false, "No page configured for tab %d" % tab)
