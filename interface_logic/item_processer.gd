extends Interactable

@export var processing_verb: String
@export var preperation_process_scene: PackedScene
# NOTE/TODO: could there be issues with instancing the process tree scene once per tool, with multiple of the same tool types in the scene?
# At best it's wasteful, at worst could cause unexpected behavior. See if there is a way to use the scene without making individual instances.
@onready var preperation_process: ProcessStep = preperation_process_scene.instantiate()
@export var processor_effects: ProcessorFx
@export var timer: Timer

var can_accept_items: bool = true

var process_step: ProcessStep = null
var recipe_component_index: int = 0

var previous_step_ingredients: Array[Ingredient]
var current_step_ingredients: Array[Ingredient]

# Signals
signal process_step_changed(process_step)
signal process_started
signal process_finished
signal process_step_started
signal process_step_finished
signal result_ingredient_produced(ingredient)

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	if preperation_process != null:
		process_step = preperation_process
		display_name = preperation_process.get_display_name()
	processor_effects.timer = timer

func can_accept_item(item: Ingredient) -> bool:
	return can_accept_items and process_step.does_any_child_require_ingredient(current_step_ingredients, item)

func try_insert_item(item: Ingredient) -> bool:
	if not can_accept_items or pickable_item != null:
		return false
	if process_step.does_any_child_require_ingredient(current_step_ingredients, item):
		current_step_ingredients.append(item)
		item_inserted.emit(item)
		check_progress()
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_sprite.texture = item.texture
		set_display_name()
		return true
	else:
		return false

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		item_sprite.modulate = Color(1, 1, 1, 0.5)
		item_reserved.emit(pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		var temp_item = pickable_item
		pickable_item = null
		display_name = preperation_process.get_display_name()
		item_sprite.texture = null
		item_removed.emit(temp_item)
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if pickable_item != null:
		is_item_reserved = false
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_returned.emit(pickable_item)
		return true
	else:
		return false

func set_display_name():
	display_name = preperation_process.get_display_name()
	if current_step_ingredients.size() > 0:
		var ingredient_name_array = PackedStringArray()
		for ingredient in current_step_ingredients:
			ingredient_name_array.append(ingredient.display_name)
		var ingredients_list = ", ".join(ingredient_name_array)
		display_name = "{0} with {1}".format([display_name, ingredients_list])

func set_tooltip():
	var ingredient_name_array = PackedStringArray()
	for ingredient in previous_step_ingredients:
		ingredient_name_array.append(ingredient.display_name)
	var ingredients_list = "\n- ".join(ingredient_name_array)
	tooltip = "Contains: \n- {0}".format([ingredients_list])

func check_progress():
	var next_step = process_step.check_child_requirements(current_step_ingredients)
	if next_step != null:
		advance_processing_step(next_step)
		start_processing_countdown()
		display_name = processing_verb

func check_for_result():
	if process_step.has_result():
		finish_recipe()

func advance_processing_step(next_step: ProcessStep):
	if process_step == preperation_process:
		process_started.emit()
	process_step = next_step
	previous_step_ingredients.append_array(current_step_ingredients)
	current_step_ingredients.clear()
	set_tooltip()
	process_step_changed.emit(process_step)

func start_processing_countdown():
	timer.start(process_step.time_to_complete)
	can_accept_items = false
	process_step_started.emit()

func finish_recipe():
	process_finished.emit()
	
	pickable_item = process_step.get_data()
	item_sprite.modulate = Color(1, 1, 1, 1)
	item_sprite.texture = pickable_item.texture
	display_name = pickable_item.display_name
	tooltip = ""
	result_ingredient_produced.emit(pickable_item)
	
	process_step = preperation_process
	previous_step_ingredients.clear()
	current_step_ingredients.clear()

func _on_Timer_timeout():
	can_accept_items = true
	set_display_name()
	process_step_finished.emit()
	check_for_result()
