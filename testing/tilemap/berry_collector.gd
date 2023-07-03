extends Area2D

var berry_count: int = -1
var collected_count: int = 0

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
	collected_count += 1
	if collected_count >= berry_count:
		all_collected.emit()
