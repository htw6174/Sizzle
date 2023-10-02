extends Interactable

enum ToolStates {
	EMPTY,
	WAITING,
	PROCESSING,
	FINISHED_NO_OPTIONS,
	FINISHED_WITH_OPTIONS
}

@export var tool_type: Cookbook.ToolTypes

@export var processor_effects: ProcessorFx
@export var timer: Timer

var current_state: ToolStates = ToolStates.EMPTY
var result_item: Ingredient

var processing_tool: ProcessingTool

var can_accept_items: bool:
	get:
		return current_state == ToolStates.EMPTY || current_state == ToolStates.FINISHED_WITH_OPTIONS

var active_process_step: ProcessStep = null
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
	processing_tool = Cookbook.get_tool_by_type(tool_type)
	processor_effects.timer = timer
	self.reset()

func can_accept_item(item: Ingredient) -> bool:
	if can_accept_items:
		if active_process_step:
			return Cookbook.is_ingredient_valid_optional(active_process_step, item)
		else:
			return Cookbook.does_ingredient_have_recipe(processing_tool, item)
	else:
		return false

func try_insert_item(item: Ingredient) -> bool:
	if not can_accept_items:
		return false
	if active_process_step:
		# moving from one step to another
		if Cookbook.is_ingredient_valid_optional(active_process_step, item):
			advance_processing_step(Cookbook.get_optional_step_by_ingredient(active_process_step, item))
			_item_inserted(item)
			return true
		else:
			return false
	else:
		# entering recipe tree
		if Cookbook.does_ingredient_have_recipe(processing_tool, item):
			item_sprite.texture = item.texture
			_item_inserted(item)
			check_options(item)
			return true
		else:
			return false

func _item_inserted(item: Ingredient):
	current_step_ingredients.append(item)
	item_sprite.modulate = Color(1, 1, 1, 1)
	set_display_name()
	item_inserted.emit(item)

func try_reserve_item() -> Ingredient:
	if result_item != null:
		is_item_reserved = true
		item_sprite.modulate = Color(1, 1, 1, 0.5)
		item_reserved.emit(result_item)
		return result_item
	else:
		return null

func try_take_item() -> Ingredient:
	if result_item != null:
		is_item_reserved = false
		var temp_item = result_item
		self.reset()
		item_removed.emit(temp_item)
		# TODO: a bit hacky to do this here; just need to ensure that processing fx stop when intermediate result is removed
		if current_state == ToolStates.FINISHED_WITH_OPTIONS:
			process_finished.emit()
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if result_item != null:
		is_item_reserved = false
		item_sprite.modulate = Color(1, 1, 1, 1)
		item_returned.emit(result_item)
		return true
	else:
		return false

func set_display_name():
	display_name = processing_tool.name
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

func reset():
	current_step_ingredients.clear()
	previous_step_ingredients.clear()
	item_sprite.texture = null
	current_state = ToolStates.EMPTY
	active_process_step = null
	result_item = null
	set_display_name()

func check_options(item: Ingredient):
	var next_step_options = Cookbook.get_recipes(processing_tool, item)
	if next_step_options.size() == 0:
		pass
	elif next_step_options.size() == 1:
		advance_processing_step(next_step_options[0])
	else:
		# TODO: present options
		Game.prompt_recipe_selection(next_step_options, _on_recipe_selected)
		current_state = ToolStates.WAITING

func check_for_result():
	if active_process_step.has_result():
		result_item = active_process_step.result
		result_ingredient_produced.emit(result_item)
		if Cookbook.does_step_have_optionals(active_process_step):
			# intermediate result
			current_state = ToolStates.FINISHED_WITH_OPTIONS
		else:
			current_state = ToolStates.FINISHED_NO_OPTIONS
			finish_recipe()

func advance_processing_step(next_step: ProcessStep):
	if active_process_step == null:
		process_started.emit()
	active_process_step = next_step
	previous_step_ingredients.append_array(current_step_ingredients)
	current_step_ingredients.clear()
	set_tooltip()
	process_step_changed.emit(active_process_step)
	start_processing_countdown()

func start_processing_countdown():
	timer.start(active_process_step.time_to_complete)
	current_state = ToolStates.PROCESSING
	display_name = processing_tool.verb
	process_step_started.emit()

func finish_recipe():
	process_finished.emit()
	
	item_sprite.modulate = Color(1, 1, 1, 1)
	item_sprite.texture = result_item.texture
	display_name = result_item.display_name
	tooltip = ""

func _on_Timer_timeout():
	set_display_name()
	process_step_finished.emit()
	check_for_result()

func _on_recipe_selected(recipe: ProcessStep):
	advance_processing_step(recipe)
