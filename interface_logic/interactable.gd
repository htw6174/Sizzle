extends Node

class_name Interactable

signal object_picked
signal object_dropped

export(String) var display_name
export(Resource) var pickable_item
export(NodePath) var item_sprite_path
onready var item_sprite: Sprite = get_node(item_sprite_path)

var tooltip: String = ""
var is_tooltip_hidden: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if pickable_item != null:
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_pickable_item(new_item):
	pickable_item = new_item
	if new_item == null:
		display_name = ""
		item_sprite.texture = null
	else:
		display_name = new_item.display_name
		item_sprite.texture = new_item.texture # TODO: need a way to more reliably make a sprite's texture match the 'active' item texture

func handle_mouse_entered():
	PlayerHand.notify_interactable_entered(self)

func handle_mouse_exited():
	PlayerHand.notify_interactable_exited(self)

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, pickable_item == null)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if pickable_item == null:
		pickable_item = item
		item_sprite.texture = pickable_item.texture
		return true
	else:
		return false

func _on_Area2D_mouse_entered():
	handle_mouse_entered()

func _on_Area2D_mouse_exited():
	handle_mouse_exited()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			handle_interaction()
