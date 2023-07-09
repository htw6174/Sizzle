extends Area2D

@export var audioplayer: AudioStreamPlayer
@export var basket: Wiggler

var berry_count: int = -1
var collected_count: int = 0

var pitch_min: float = 0.75

signal all_collected

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_berry_picker_minigame_start(count, _area):
	berry_count = count
	collected_count = 0

func _on_body_entered(body):
	body.queue_free()
	collected_count += 1
	# from 0 to berry_count, goes from 1.0 to pitch_min
	audioplayer.pitch_scale = lerp(1.0, pitch_min, float(collected_count) / berry_count)
	audioplayer.play()
	basket.wiggle()
	if collected_count >= berry_count:
		all_collected.emit()
