extends PointLight2D

@export var plane_radius: float = 80.0
@export var depth_radius: float = 20.0
@export var vertical_factor: float = 0.5
@export var period_seconds: float = 1.5

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
