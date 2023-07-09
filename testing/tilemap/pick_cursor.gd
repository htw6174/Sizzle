extends Area2D

@export var force_mag: float = 10.0
@export var audioplayer: AudioStreamPlayer

var mouse_velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseMotion:
		self.global_position = get_global_mouse_position()
		self.mouse_velocity = event.velocity

func _on_area_entered(area):
	pass


func _on_body_entered(body):
	if body is RigidBody2D && mouse_velocity.length() > 0.1:
		var rb = body as RigidBody2D
		# (body as RigidBody2D).set_freeze_enabled(false)
		rb.gravity_scale = 2.0
		var force_dir = mouse_velocity.normalized()
		rb.apply_impulse(Vector2(force_dir.x * force_mag, -force_mag))
		audioplayer.pitch_scale = randf_range(0.8, 1.2);
		audioplayer.play()
