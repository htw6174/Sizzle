extends Label

func _process(delta):
	grow_to_screen_area()

func grow_to_screen_area():
	var pos = self.rect_global_position
	var screen = get_viewport_rect().size
	if pos.x > (screen.x / 2):
		self.grow_horizontal = GROW_DIRECTION_BEGIN
	else:
		self.grow_horizontal = GROW_DIRECTION_END
