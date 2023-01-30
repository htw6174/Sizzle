extends Sprite

signal object_picked

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Resource) var ingredient

# Called when the node enters the scene tree for the first time.
func _ready():
	if ingredient != null:
		self.texture = ingredient.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if PlayerHand.player_pickup(ingredient):
				emit_signal("object_picked")
