extends MarginContainer

@export var widget_parent: Control

@export var tool_widget_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for tool in Cookbook.tools:
		var widget = tool_widget_scene.instantiate() as ToolWidget
		widget.tool = tool
		widget_parent.add_child(widget)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
