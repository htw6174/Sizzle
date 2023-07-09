class_name Wiggler
extends Sprite2D

var radius: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# TODO: consider using a coroutine or similar instead of checking every frame
	if radius > 0.1:
		var wigglex = randf()
		self.offset = Vector2(wigglex * radius, (1.0 - wigglex) * radius)
		radius = radius * 0.9


func wiggle(strength: float = 1.0):
	radius += strength
