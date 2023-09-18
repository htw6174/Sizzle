extends Interactable
class_name ServingDish

@export var dish_tree_root: DishStep
@export var sprites_anchor: Node2D
@export var serving_effects: ServingEffects

var dish_step: DishStep

var step_components: Array[DishComponent]
var added_ingredients: Array[Ingredient]

signal dish_complete(dish_step, added_ingredients)
signal dish_served(dish_step: DishStep, added_ingredients: Array[Ingredient])

func _ready():
	super()
	reset()
	set_tooltip()

func reset():
	dish_step = dish_tree_root
	step_components = dish_step.components.duplicate()
	added_ingredients = []
	set_tooltip()
	# destroy component sprites
	var sprites = sprites_anchor.get_children()
	for sprite in sprites:
		sprite.queue_free()

func handle_interaction():
	pass

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func add_sprite_layer(parent: Node2D, texture: Texture2D, depth: int):
	var item_sprite = Sprite2D.new()
	parent.add_child(item_sprite)
	#item_sprite.texture = next_step.sprite_frames.get_frame_texture("default", next_step.frame_index)
	item_sprite.texture = texture
	item_sprite.z_index = depth

func change_step(new_step: DishStep, initial_ingredient: Ingredient) -> DishComponent:
	dish_step = new_step
	
	step_components = new_step.components.duplicate()
	
	# messy, re-checking this here b/c GDScript lacks out params / multiple returns
	var initial_component: DishComponent = null
	for component in step_components:
		if component.accepts_ingredient(initial_ingredient):
			initial_component = component
			break
	assert(initial_component != null, "Initial ingredient not valid component of new step")
	return initial_component

func try_add_ingredient(ingredient: Ingredient) -> DishComponent:
	# is ingredient an option of any remaining current step component?
	# also check if any requirements remain
	var requirements_filled = true
	for component in step_components:
		if component.accepts_ingredient(ingredient):
			return component
		if component.required:
			requirements_filled = false
	# if not accepted by current step but requirements filled then child steps can also be checked:
	if requirements_filled:
		# check child steps
		var next_step = dish_step.child_accepting_ingredient(ingredient)
		if next_step != null:
			return change_step(next_step, ingredient)
	
	return null

func try_insert_item(item: Ingredient) -> bool:
	var added_component = try_add_ingredient(item)
	if added_component:
		# create new sprite node
		# FIXME: need to get component option for sprite, not just component
		# temp dumb hack: just determine it again
		var component_option = added_component.matching_option(item)
		add_sprite_layer(sprites_anchor, component_option.texture, component_option.depth)
		if component_option.background_texture != null:
			add_sprite_layer(sprites_anchor, component_option.background_texture, component_option.background_depth)
		# update dish tracking
		added_ingredients.append(item)
		step_components.erase(added_component)
		# other fx
		set_tooltip()
		return true
	else:
		return false

func set_tooltip():
	if dish_step == dish_tree_root:
		tooltip = "Serving Area"
	else:
		var ingredient_name_array = PackedStringArray()
		for ingredient in added_ingredients:
			ingredient_name_array.append(ingredient.display_name)
		var ingredients_list = "\n- ".join(ingredient_name_array)
		tooltip = "{0}\n- {1}".format([dish_step.name, ingredients_list])

func _on_bell_rung():
	serving_effects.serve()

func _on_dish_effects_exit_finished():
	dish_served.emit(dish_step, added_ingredients)
	reset()
	serving_effects.new_dish()
