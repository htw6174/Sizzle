extends Button

export(String) var target_name: String
export(NodePath) var target_path 
onready var target: Node = get_node(target_path)

func _ready():
	self.connect("pressed", self, "_on_Button_pressed")
	target.connect("visibility_changed", self, "_on_Target_visibility_changed")
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
