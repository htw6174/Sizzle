extends HSlider

@export var bus_name: String = "Master"

@onready var _bus = AudioServer.get_bus_index(bus_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))


func _on_value_changed(value):
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
