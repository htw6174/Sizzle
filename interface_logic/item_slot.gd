extends Node

class_name ItemSlot

signal object_picked
signal object_dropped

export(Resource) var pickable_item
export(NodePath) var item_sprite_path
onready var item_sprite: Sprite = get_node(item_sprite_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	if pickable_item != null:
		item_sprite.texture = pickable_item.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_interaction():
	if pickable_item != null:
		take_item()
	else:
		insert_item()

func insert_item():
	pickable_item = PlayerHand.player_drop()
	item_sprite.texture = pickable_item.texture
	
func take_item():
	if PlayerHand.player_pickup(pickable_item):
		pickable_item = null
		item_sprite.texture = null
	

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			handle_interaction()

