extends Control

func _process(delta):
	grow_to_screen_area()

func grow_to_screen_area():
	var screen = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var rect_right = mouse_pos.x + self.size.x
	if rect_right > screen.x:
		self.grow_horizontal = GROW_DIRECTION_BEGIN
		#subtooltip.grow_horizontal = GROW_DIRECTION_BEGIN
	else:
		self.grow_horizontal = GROW_DIRECTION_END
		#subtooltip.grow_horizontal = GROW_DIRECTION_END
	
	var rect_bottom = get_viewport().get_mouse_position().y + self.size.y
	if rect_bottom > screen.y:
		self.grow_vertical = GROW_DIRECTION_BEGIN
	else:
		self.grow_vertical = GROW_DIRECTION_END
