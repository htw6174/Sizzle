@icon("res://sprites/cutting board log.png")
extends Node
class_name ProcessingTool

@export var tool_type: Cookbook.ToolTypes
@export_multiline var description: String
@export var verb: String = "making"
@export var icon: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

