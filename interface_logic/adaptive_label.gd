extends Label

func _process(delta):
	grow_to_screen_area()

func grow_to_screen_area():
	var rect_right = self.get_parent().position.x + rect_size.x
	var screen = get_viewport_rect().size
	if rect_right > screen.x:
		self.grow_horizontal = GROW_DIRECTION_BEGIN
	else:
		self.grow_horizontal = GROW_DIRECTION_END
	
	var rect_bottom = self.get_parent().position.y + rect_size.y
	if rect_bottom > screen.y:
		self.grow_vertical = GROW_DIRECTION_BEGIN
	else:
		self.grow_vertical = GROW_DIRECTION_END
