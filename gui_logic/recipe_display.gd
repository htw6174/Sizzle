extends Control
class_name RecipeDisplay

@export var recipe_step: ProcessStep:
	get:
		return recipe_step
	set(value):
		recipe_step = value
		update_display()

@export var tool_icon: TextureRect
@export var components_parent: Control
@export var result_label: Label
@export var time_label: Label
@export var result: IngredientIcon

@export var icon_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_display():
	if recipe_step:
		# Set tool icon
		# TODO: ensure this works for nested process steps
		var tool = recipe_step.get_parent()
		if tool is ProcessingTool:
			tool_icon.texture = tool.icon
			tool_icon.tooltip_text = tool.name
		
		# Clear old components
		var to_clear = components_parent.get_children()
		for node in to_clear:
			node.queue_free()
		
		# Create component icons
		for ingredient in recipe_step.ingredients:
			var new_icon = icon_scene.instantiate() as IngredientIcon
			new_icon.ingredient = ingredient
			components_parent.add_child(new_icon)
		
		# Set name of result ingredient
		result_label.text = recipe_step.result.display_name
		
		# Set duration text
		time_label.text = "%.fs" % recipe_step.time_to_complete
		
		# Set result icon
		if recipe_step.result:
			result.ingredient = recipe_step.result
		else:
			# TODO: handling for multi-step recipes and/or a warning for steps without results
			result.ingredient = null
	else:
		# TODO: put some default icons in, or hide the whole element
		pass
