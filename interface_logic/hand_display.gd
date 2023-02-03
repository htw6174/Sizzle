extends Sprite

export(NodePath) var label_path
onready var label: Label = get_node(label_path)

func _process(delta):
	# follow mouse
	self.position = get_viewport().get_mouse_position()
	
	if PlayerHand.hovered_interactable != null:
		label.text = PlayerHand.hovered_interactable.display_name
	else:
		label.text = ""
	
	if PlayerHand.held_item != null:
		self.texture = PlayerHand.held_item.texture
		#self.visible = true
	else:
		self.texture = null
		#self.visible = false
