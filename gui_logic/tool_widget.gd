extends Control
class_name ToolWidget

@export var tool: ProcessingTool:
	get:
		return tool
	set(value):
		tool = value
		texture.texture = tool.icon
		name_label.text = tool.name
		description_label.text = tool.description

@export var texture: TextureRect
@export var name_label: Label
@export var description_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
