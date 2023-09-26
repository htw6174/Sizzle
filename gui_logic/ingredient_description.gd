extends Control
class_name IngredientDescription

@export var ingredient: Ingredient:
	get:
		return ingredient
	set(value):
		ingredient = value
		icon.texture = ingredient.texture
		title.text = ingredient.display_name

@export var icon: TextureRect
@export var title: Label
@export var description: RichTextLabel
@export var attributes: RichTextLabel
@export var stats: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	description.text = "Description: Coming Soon!"
	attributes.text = "Attributes: Coming Soon!"
	stats.text = "Stats: Coming Soon!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
