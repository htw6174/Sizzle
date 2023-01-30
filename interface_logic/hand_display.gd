extends Sprite

func _process(delta):
	# follow mouse
	self.position = get_viewport().get_mouse_position()
	
	if PlayerHand.held_item != null:
		self.texture = PlayerHand.held_item.texture
		#self.visible = true
	else:
		self.texture = null
		#self.visible = false
