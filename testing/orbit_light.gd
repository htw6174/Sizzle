extends Light2D

var plane_radius = 80.0
var depth_radius = 20.0
var vertical_factor = 0.5

var period_seconds = 1.5

var start_position: Vector2

func _init():
	start_position = self.position

func _process(delta):
	var seconds = Time.get_ticks_msec() / 1000.0
	var theta = (seconds * TAU) / period_seconds
	var x = sin(theta) * plane_radius
	var y = -sin(theta) * plane_radius * vertical_factor
	var z = cos(theta)
	self.position = start_position + Vector2(x, y)
	self.range_height = z * depth_radius
	self.energy = clamp(z, 0, 1)
