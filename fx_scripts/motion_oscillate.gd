extends Node2D

@export var x_phase: float = 0
@export var x_frequency: float = 1
@export var x_amplitude: float = 1
@export var y_phase: float = 0
@export var y_frequency: float = 1
@export var y_amplitude: float = 1
@export var time_scale: float = 1

var random_phase: float
var start_position: Vector2

func _ready():
	random_phase = randf_range(0, 1.0 / x_frequency)
	start_position = self.position

func _process(delta):
	var seconds = (Time.get_ticks_msec() / 1000.0) * time_scale
	var x_theta = (seconds + x_phase + random_phase) * x_frequency * TAU
	var y_theta = (seconds + y_phase + random_phase) * y_frequency * TAU
	var x = sin(x_theta) * x_amplitude
	var y = sin(y_theta) * y_amplitude
	self.position = start_position + Vector2(x, y)
