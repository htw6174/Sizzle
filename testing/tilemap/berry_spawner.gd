extends Node2D

@export var berry_scene: PackedScene
@export var margin: int = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_berries(count: int, area: Vector2):
	for i in range(count):
		var new_berry = berry_scene.instantiate() as RigidBody2D
		add_child(new_berry)
		new_berry.position = Vector2(randf_range(margin, area.x - margin), randf_range(margin, area.y - margin))

func _on_spawn_request(count: int, area: Vector2):
	call_deferred("spawn_berries", count, area)
