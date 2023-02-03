extends Interactable

export(Resource) var preperation_process
export(NodePath) var processing_animation_path
onready var processing_animation: AnimatedSprite = get_node(processing_animation_path)
export(NodePath) var timer_path
onready var timer: Timer = get_node(timer_path)
export(NodePath) var audio_player_path
onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)

var active_recipe: Recipe = null
var recipe_component_index: int = 0

var primary_ingredient: Ingredient
var secondary_ingredients: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	if preperation_process != null:
		display_name = preperation_process.display_name
	processing_animation.visible = false

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, pickable_item == null)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null
	display_name = preperation_process.display_name

func try_insert_item(item: Ingredient) -> bool:
	if active_recipe == null:
		# use ingredient to pick recipe
		for recipe in preperation_process.supported_recipes:
			if item == recipe.primary_ingredient:
				active_recipe = recipe
				primary_ingredient = item
				set_display_name()
				check_recipe_complete()
				return true
		return false
	else:
		if active_recipe.can_add_ingredient(item, secondary_ingredients):
			secondary_ingredients.append(item)
			set_display_name()
			check_recipe_complete()
			return true
		else:
			return false

func set_display_name():
	var base_name = "{0}ing {1}".format([preperation_process.display_name, primary_ingredient.display_name])
	var ingredient_name_array = PoolStringArray()
	ingredient_name_array.append(base_name)
	for ingredient in secondary_ingredients:
		ingredient_name_array.append(ingredient.display_name)
	display_name = ingredient_name_array.join(", ")

func check_recipe_complete():
	var matching_component_count = 0
	var required_component_count = active_recipe.components.size()
	for component in active_recipe.components:
		if component in secondary_ingredients:
			matching_component_count += 1
	if matching_component_count == required_component_count:
		start_processing_countdown()

func start_processing_countdown():
	processing_animation.visible = true
	processing_animation.play()
	audio_player.play()
	timer.start(active_recipe.processing_time)

func finish_recipe():
	processing_animation.visible = false
	processing_animation.stop()
	audio_player.stop()
	
	pickable_item = active_recipe.result_ingredient
	item_sprite.texture = pickable_item.texture
	display_name = pickable_item.display_name
		
	active_recipe = null
	primary_ingredient = null
	secondary_ingredients.clear()

func _on_Timer_timeout():
	finish_recipe()
