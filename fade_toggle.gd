extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadeInColor: Color = Color(1, 1, 1, 1)
var fadeOutColor: Color = Color(1, 1, 1, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ingredient_object_dropped():
	self.set_modulate(fadeInColor)


func _on_Ingredient_object_picked():
	self.set_modulate(fadeOutColor)
