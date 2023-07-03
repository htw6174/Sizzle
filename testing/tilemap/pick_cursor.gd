extends Area2D

@export var force_mag: float = 10.0
var force_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		self.position = get_global_mouse_position()
		self.force_dir = event.relative.normalized()

func _on_area_entered(area):
	pass


func _on_body_entered(body):
	if body is RigidBody2D:
		var rb = body as RigidBody2D
		# (body as RigidBody2D).set_freeze_enabled(false)
		rb.gravity_scale = 1.0
		rb.apply_impulse(force_dir * force_mag)
