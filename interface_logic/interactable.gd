extends Node

class_name Interactable

signal mouse_entered(interactable)
signal mouse_exited(interactable)
signal interacted(interactable)
signal item_inserted(item)
signal item_reserved(item)
signal item_removed(item)

export(String) var display_name
export(Resource) var pickable_item
export(NodePath) var item_sprite_path
onready var item_sprite: Sprite = get_node(item_sprite_path)

var is_item_reserved: bool = false

var tooltip: String = ""
var is_tooltip_hidden: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("mouse_entered", PlayerHand, "_on_Interactable_mouse_entered")
	self.connect("mouse_exited", PlayerHand, "_on_Interactable_mouse_exited")
	self.connect("interacted", PlayerHand, "_on_Interactable_interacted")
	if pickable_item != null:
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func can_accept_item(item: Ingredient) -> bool:
	return item != null and pickable_item == null

func try_insert_item(item: Ingredient) -> bool:
	if pickable_item == null:
		emit_signal("item_inserted", item)
		pickable_item = item
		display_name = item.display_name
		item_sprite.texture = item.texture
		return true
	else:
		return false

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		display_name = ""
		item_sprite.texture = null
		emit_signal("item_reserved", pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		var temp_item = pickable_item
		pickable_item = null
		display_name = ""
		item_sprite.texture = null
		emit_signal("item_removed", temp_item)
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if pickable_item != null:
		is_item_reserved = false
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture
		return true
	else:
		return false

# should be treated as protected
func set_pickable_item(new_item):
	pickable_item = new_item
	if new_item == null:
		display_name = ""
		item_sprite.texture = null
	else:
		display_name = new_item.display_name
		item_sprite.texture = new_item.texture # TODO: need a way to more reliably make a sprite's texture match the 'active' item texture

func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered", self)

func _on_Area2D_mouse_exited():
	emit_signal("mouse_exited", self)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("interacted", self)
