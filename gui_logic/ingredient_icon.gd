@tool
extends TextureButton
class_name IngredientIcon

@export var ingredient: Ingredient:
	get:
		return ingredient
	set(value):
		ingredient = value
		update_display()

# Called when the node enters the scene tree for the first time.
func _ready():
	update_display()
	if Engine.is_editor_hint():
		pass
	else:
		self.pressed.connect(self._on_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_display():
	if ingredient:
		self.texture_normal = ingredient.texture
		self.tooltip_text = ingredient.display_name
	else:
		self.texture_normal = null
		self.tooltip_text = ""

func _on_pressed():
	Game.inspect_ingredient(ingredient)

#TODO: on-hover label
