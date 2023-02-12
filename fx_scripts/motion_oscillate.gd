extends Node2D

export(float) var x_phase = 0
export(float) var x_frequency = 1
export(float) var x_amplitude = 1
export(float) var y_phase = 0
export(float) var y_frequency = 1
export(float) var y_amplitude = 1
export(float) var time_scale = 1

var random_phase: float
var start_position: Vector2

func _ready():
	random_phase = rand_range(0, 1.0 / x_frequency)
	start_position = self.position

func _process(delta):
	var seconds = (Time.get_ticks_msec() / 1000.0) * time_scale
	var x_theta = (seconds + x_phase + random_phase) * x_frequency * TAU
	var y_theta = (seconds + y_phase + random_phase) * y_frequency * TAU
	var x = sin(x_theta) * x_amplitude
	var y = sin(y_theta) * y_amplitude
	self.position = start_position + Vector2(x, y)
