extends Light2D

var radius = 80.0
var period_seconds = 2.0
var start_position: Vector2

func _init():
	start_position = self.position

func _process(delta):
	var seconds = Time.get_ticks_msec() / 1000.0
	var x = sin(seconds) * radius
	var y = cos(seconds) * radius
	self.position = start_position + Vector2(x, y)
