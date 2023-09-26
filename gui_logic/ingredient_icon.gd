extends TextureButton

var ingredient: Ingredient:
	get:
		return ingredient
	set(value):
		ingredient = value
		self.texture_normal = ingredient.texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
