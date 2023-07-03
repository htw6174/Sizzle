extends Node2D

@export var tilemap: TileMap
@export var inspector: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_primary()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			interact_secondary()
	if event is InputEventMouseMotion:
		# need reference to tilemap
		var mouse_local_pos = tilemap.get_local_mouse_position()
		# convert mouse position to local coords for tilemap, then to tile vec2i
		var hovered_tile = tilemap.local_to_map(mouse_local_pos)
		var cell_data = tilemap.get_cell_tile_data(1, hovered_tile)
		var cell_id = tilemap.get_cell_atlas_coords(1, hovered_tile)
		inspector.text = "{0}: ID {1}".format([hovered_tile, cell_id])

func interact_primary():
	pass

func interact_secondary():
	pass
