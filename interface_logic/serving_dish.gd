extends Interactable

export(Resource) var target_dish
export(NodePath) var ingredients_parent_path
onready var ingredients_parent: Node2D = get_node(ingredients_parent_path)

var dish_component_index: int = 0
var added_ingredients: Array = []

var is_dish_complete: bool = false

func handle_interaction():
	PlayerHand.notify_interaction(self, null, true)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if target_dish.can_add_ingredient(item, added_ingredients):
		# create new sprite node
		var item_sprite = Sprite.new()
		ingredients_parent.add_child(item_sprite)
		item_sprite.texture = item.texture
		# check added ingredients against recipe
		added_ingredients.append(item)
		check_dish_complete()
		return true
	else:
		return false

func check_dish_complete():
	var dish = target_dish as Dish
	#TODO
