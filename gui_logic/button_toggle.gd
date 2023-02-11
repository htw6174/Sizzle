extends Button

export(String) var target_name: String
export(NodePath) var target_path 
onready var target: Node = get_node(target_path)

func _ready():
	self.connect("pressed", self, "_on_Button_pressed")
	update_text()

func update_text():
	if target:
		if target.visible:
			self.text = "Hide {0}".format([target_name])
		else:
			self.text = " v "

func _on_Button_pressed():
	if target:
		target.visible = not target.visible
		update_text()
