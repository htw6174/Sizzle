extends Node

#@export var freeplay_controller: PackedScene
var freeplay_controller = preload("res://gameplay_logic/freeplay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func begin_tutorial():
	pass

func begin_freeplay():
	var fp = freeplay_controller.instantiate()
	self.add_child(fp)
