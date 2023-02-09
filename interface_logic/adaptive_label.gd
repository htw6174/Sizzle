extends Label

func _process(delta):
	grow_to_screen_area()

func grow_to_screen_area():
	var rect_right = get_viewport().get_mouse_position().x + rect_size.x
	var screen = get_viewport_rect().size
	if rect_right > screen.x:
		self.grow_horizontal = GROW_DIRECTION_BEGIN
	else:
		self.grow_horizontal = GROW_DIRECTION_END
	
	var rect_bottom = get_viewport().get_mouse_position().y + rect_size.y
	if rect_bottom > screen.y:
		self.grow_vertical = GROW_DIRECTION_BEGIN
	else:
		self.grow_vertical = GROW_DIRECTION_END
