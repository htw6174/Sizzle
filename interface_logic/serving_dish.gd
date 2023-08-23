extends Interactable

@export var dish_tree_root: DishStep
@export var dish_animation: AnimatedSprite2D
@export var sprites_anchor: Node2D
@export var animation_player: AnimationPlayer

var dish_step: DishStep
var active_spritesheet: Texture2D = null

var step_components: Array[DishComponent]
var added_ingredients: Array[Ingredient]

signal dish_complete(dish_step)

func _ready():
	super()
	dish_step = dish_tree_root
	step_components = dish_step.components.duplicate()
	set_tooltip()

func handle_interaction():
	pass

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func add_sprite_layer(parent: Node2D, sprite_sheet: Texture2D, sprite_coord: Vector2i, sprite_size: Vector2i = Vector2i(59, 37)):
	var item_sprite = Sprite2D.new()
	parent.add_child(item_sprite)
	#item_sprite.texture = next_step.sprite_frames.get_frame_texture("default", next_step.frame_index)
	item_sprite.texture = sprite_sheet
	item_sprite.region_enabled = true
	item_sprite.region_rect = Rect2(sprite_coord.x * sprite_size.x, sprite_coord.y * sprite_size.y, sprite_size.x, sprite_size.y)
	item_sprite.z_index = sprite_coord.x

func change_step(new_step: DishStep, initial_ingredient: Ingredient) -> DishComponent:
	dish_step = new_step
	if new_step.sprite_sheet != null:
		active_spritesheet = new_step.sprite_sheet
	
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
		add_sprite_layer(sprites_anchor, active_spritesheet, component_option.sprite_coord)
		if component_option.background_coord.x > -1 && component_option.background_coord.y > -1:
			add_sprite_layer(sprites_anchor, active_spritesheet, component_option.background_coord)
		# update dish tracking
		added_ingredients.append(item)
		step_components.erase(added_component)
		# other fx
		set_tooltip()
		return true
	else:
		return false
#	var next_step: DishStep = dish_step.check_child_requirements(item)
#	if next_step:
#		# determine which component variant to use
#		var next_component = next_step.check_components(item)
#		# create new sprite node
#		add_sprite_layer(sprites_anchor, next_step.sprite_sheet, next_component.sprite_coord)
#		if next_component.background_coord.x > -1 && next_component.background_coord.y > -1:
#			add_sprite_layer(sprites_anchor, next_step.sprite_sheet, next_component.background_coord)
#		added_ingredients.append(item)
#		dish_step = next_step
#		set_tooltip()
#		return true
#	else:
#		return false

func serve():
	animation_player.play("dish_complete")
	
	dish_step = dish_tree_root
	step_components = dish_step.components.duplicate()

func set_tooltip():
	if dish_step == dish_tree_root:
		tooltip = "Serving Area"
	else:
		var ingredient_name_array = PackedStringArray()
		for ingredient in added_ingredients:
			ingredient_name_array.append(ingredient.display_name)
		var ingredients_list = "\n- ".join(ingredient_name_array)
		tooltip = "{0}\n- {1}".format([dish_step.name, ingredients_list])

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dish_complete":
		dish_complete.emit(dish_step)
