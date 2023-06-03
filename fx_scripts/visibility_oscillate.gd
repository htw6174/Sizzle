extends Node2D

@export var max_visibility: float = 1
@export var min_visibliity: float = -1
@export var period_seconds: float = 1.0
@export var scale_min: float = 0.1
@export var scale_max: float = 0.3

var random_delay: float
var start_visibility: float

func _ready():
	random_delay = randf_range(0, period_seconds)
	start_visibility = self.modulate.a
	var rand_scale = randf_range(scale_min, scale_max)
	self.scale.x = rand_scale
	self.scale.y = rand_scale

func _process(delta):
	var center = (max_visibility + min_visibliity) / 2.0
	var amplitude = max_visibility - center
	
	var seconds = random_delay + (Time.get_ticks_msec() / 1000.0)
	var theta = (seconds * TAU) / period_seconds
	var x = (sin(theta) * amplitude) + center
	var alpha = clamp(x, 0, 1)
	self.modulate = Color(1, 1, 1, alpha)
