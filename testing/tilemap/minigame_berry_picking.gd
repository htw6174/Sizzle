extends Control

@export var berry_count: int = 100

signal minigame_start(count: int, area: Vector2)
signal minigame_complete
signal minigame_quit

# Called when the node enters the scene tree for the first time.
func _ready():
	start_minigame()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_collection_area_all_collected():
	start_minigame()


func start_minigame():
	minigame_start.emit(berry_count, self.size)
