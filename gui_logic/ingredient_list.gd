extends Control

@export var icon_scene: PackedScene
@export var grid: GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	for ingredient in Cookbook.ingredients:
		var new_icon = icon_scene.instantiate() as TextureButton
		new_icon.ingredient = ingredient
		new_icon.pressed.connect(self._on_icon_clicked.bind(ingredient))
		grid.add_child(new_icon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_icon_clicked(ingredient: Ingredient):
	Game.inspect_ingredient(ingredient)
