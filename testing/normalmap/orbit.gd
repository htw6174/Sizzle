extends PointLight2D

@export var radius: float = 80.0
@export var period_seconds: float = 2.0

var start_position: Vector2

func _init():
	start_position = self.position

func _process(delta):
	var seconds = Time.get_ticks_msec() / 1000.0
	var theta = (seconds * TAU) / period_seconds
	var x = sin(theta) * radius
	var y = cos(theta) * radius
	self.position = start_position + Vector2(x, y)
