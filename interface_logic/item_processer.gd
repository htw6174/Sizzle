extends Interactable

export(String) var processing_verb
export(PackedScene) var preperation_process_scene
onready var preperation_process: ProcessStep = preperation_process_scene.instance()
export(NodePath) var processor_effects_path
onready var processor_effects = get_node(processor_effects_path)
export(NodePath) var timer_path
onready var timer: Timer = get_node(timer_path)

var can_accept_items: bool = true

var process_step: ProcessStep = null
var recipe_component_index: int = 0

var previous_step_ingredients: Array
var current_step_ingredients: Array

# Signals
signal process_step_changed(process_step)
signal process_started
signal process_finished
signal process_step_started
signal process_step_finished
signal result_ingredient_produced(ingredient)

# Called when the node enters the scene tree for the first time.
func _ready():
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
		emit_signal("item_inserted", item)
		check_progress()
		item_sprite.texture = item.texture
		set_display_name()
		return true
	else:
		return false

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		item_sprite.modulate = Color(1, 1, 1, 0.5)
		emit_signal("item_reserved", pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		var temp_item = pickable_item
		pickable_item = null
		display_name = preperation_process.get_display_name()
		item_sprite.texture = null
		emit_signal("item_removed", temp_item)
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if pickable_item != null:
		is_item_reserved = false
		item_sprite.modulate = Color(1, 1, 1, 1)
		emit_signal("item_returned", pickable_item)
		return true
	else:
		return false

func set_display_name():
	display_name = preperation_process.get_display_name()
	if current_step_ingredients.size() > 0:
		var ingredient_name_array = PoolStringArray()
		for ingredient in current_step_ingredients:
			ingredient_name_array.append(ingredient.display_name)
		var ingredients_list = ingredient_name_array.join(", ")
		display_name = "{0} with {1}".format([display_name, ingredients_list])

func set_tooltip():
	var ingredient_name_array = PoolStringArray()
	for ingredient in previous_step_ingredients:
		ingredient_name_array.append(ingredient.display_name)
	var ingredients_list = ingredient_name_array.join("\n- ")
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
		emit_signal("process_started")
	process_step = next_step
	previous_step_ingredients.append_array(current_step_ingredients)
	current_step_ingredients.clear()
	set_tooltip()
	emit_signal("process_step_changed", process_step)

func start_processing_countdown():
	timer.start(process_step.time_to_complete)
	can_accept_items = false
	emit_signal("process_step_started")

func finish_recipe():
	emit_signal("process_finished")
	
	pickable_item = process_step.get_result()
	item_sprite.modulate = Color(1, 1, 1, 1)
	item_sprite.texture = pickable_item.texture
	display_name = pickable_item.display_name
	tooltip = ""
	emit_signal("result_ingredient_produced", pickable_item)
	
	process_step = preperation_process
	previous_step_ingredients.clear()
	current_step_ingredients.clear()

func _on_Timer_timeout():
	can_accept_items = true
	set_display_name()
	emit_signal("process_step_finished")
	check_for_result()
