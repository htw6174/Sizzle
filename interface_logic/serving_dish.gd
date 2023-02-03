extends Interactable

export(Resource) var target_dish
export(NodePath) var dish_animation_path
onready var dish_animation: AnimatedSprite = get_node(dish_animation_path)
export(NodePath) var sprites_anchor_path
onready var sprites_anchor: Node2D = get_node(sprites_anchor_path)

var dish_component_index: int = 0
var added_ingredients: Array = []

var is_dish_complete: bool = false

func _ready():
	dish_animation.frames = target_dish.texture_frames

func handle_interaction():
	PlayerHand.notify_interaction(self, null, not is_dish_complete)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if target_dish.can_add_ingredient(item, added_ingredients):
		if target_dish.is_ordered:
			# set animation frame
			dish_animation.visible = true
			dish_animation.frame = added_ingredients.size()
		else:
			# create new sprite node
			var item_sprite = Sprite.new()
			sprites_anchor.add_child(item_sprite)
			var frame_index = target_dish.components.find(item)
			item_sprite.texture = target_dish.texture_frames.get_frame("default", frame_index)
		# check added ingredients against recipe
		added_ingredients.append(item)
		check_dish_complete()
		return true
	else:
		return false

func check_dish_complete():
	var matching_component_count = 0
	var required_component_count = target_dish.components.size()
	for component in target_dish.components:
		if component in added_ingredients:
			matching_component_count += 1
	if matching_component_count == required_component_count:
		is_dish_complete = true
