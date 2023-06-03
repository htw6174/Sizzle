extends Button

@export var target_name: String: String
@export var target_path: NodePath 
@onready var target: Node = get_node(target_path)

func _ready():
	self.connect("pressed", Callable(self, "_on_Button_pressed"))
	target.connect("visibility_changed", Callable(self, "_on_Target_visibility_changed"))
	update_text()

func update_text():
	if target:
		if target.visible:
			self.text = "X"
		else:
			self.text = "?"

func _on_Button_pressed():
	if target:
		target.visible = not target.visible
		update_text()

func _on_Target_visibility_changed():
	update_text()
