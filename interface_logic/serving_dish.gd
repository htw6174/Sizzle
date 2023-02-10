extends Interactable

export(Resource) var target_dish
export(NodePath) var dish_animation_path
onready var dish_animation: AnimatedSprite = get_node(dish_animation_path)
export(NodePath) var sprites_anchor_path
onready var sprites_anchor: Node2D = get_node(sprites_anchor_path)
export(NodePath) var animation_player_path
onready var animation_player: AnimationPlayer = get_node(animation_player_path)

var dish_in_progress: Dish.DishInProgress

var is_dish_complete: bool = false

signal dish_complete(dish)

func _ready():
	change_target_dish(target_dish)
	dish_in_progress = Dish.DishInProgress.new(target_dish)
	set_tooltip()
	if target_dish.dish_texture != null:
		item_sprite.texture = target_dish.dish_texture

func change_target_dish(dish: Dish):
	target_dish = dish
	if target_dish:
		dish_animation.frames = target_dish.texture_frames
		self.display_name = "Serve a {0}".format([target_dish.display_name])

func handle_interaction():
	PlayerHand.notify_interaction(self, null, not is_dish_complete)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if dish_in_progress.can_add_ingredient(item):
		if target_dish.stack_frames:
			# create new sprite node
			var item_sprite = Sprite.new()
			sprites_anchor.add_child(item_sprite)
			var frame_index = target_dish.components.find(item)
			item_sprite.texture = target_dish.texture_frames.get_frame("default", frame_index)
		else:
			# set animation frame
			dish_animation.visible = true
			dish_animation.frame = dish_in_progress.added_ingredients.size()
		# check added ingredients against recipe
		dish_in_progress.add_ingredient(item)
		check_dish_complete()
		set_tooltip()
		return true
	else:
		return false

func check_dish_complete():
	if dish_in_progress.is_finished():
		is_dish_complete = true
		animation_player.play("dish_complete")

func set_tooltip():
	var ingredient_name_array = PoolStringArray()
	for ingredient in dish_in_progress.remaining_ingredients:
		ingredient_name_array.append(ingredient.display_name)
	var ingredients_list = ingredient_name_array.join("\n- ")
	tooltip = "- {0}".format([ingredients_list])

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dish_complete":
		emit_signal("dish_complete", target_dish)
