extends Node2D

signal object_picked
signal object_dropped

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var isPicked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			print(event.as_text())
			isPicked = not isPicked
			if isPicked:
				emit_signal("object_picked")
			else:
				emit_signal("object_dropped")
