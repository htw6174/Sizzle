extends Interactable

@export var audio_player: AudioStreamPlayer

signal bell_rung

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			audio_player.play()
			bell_rung.emit()
