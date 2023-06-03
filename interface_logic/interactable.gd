extends Node

class_name Interactable

signal mouse_entered(interactable)
signal mouse_exited(interactable)
signal interacted(interactable)
signal item_inserted(item)
signal item_reserved(item)
signal item_removed(item)
signal item_returned(item)

@export var display_name: String
@export var pickable_item: Resource
@export var item_sprite_path: NodePath
@onready var item_sprite: Sprite2D = get_node(item_sprite_path)

var is_item_reserved: bool = false

var tooltip: String = ""
var is_tooltip_hidden: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("mouse_entered", Callable(PlayerHand, "_on_Interactable_mouse_entered"))
	self.connect("mouse_exited", Callable(PlayerHand, "_on_Interactable_mouse_exited"))
	if pickable_item != null:
		display_name = pickable_item.display_name
		item_sprite.texture = pickable_item.texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func can_accept_item(item: Ingredient) -> bool:
	return item != null

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
		emit_signal("item_returned", pickable_item)
		return true
	else:
		return false

static func try_swap_item(slot1: Interactable, slot2: Interactable) -> bool:
	var item1 = slot1.pickable_item
	var item2 = slot2.pickable_item
	if slot1.can_accept_item(item2) and slot2.can_accept_item(item1):
		slot1.pickable_item = null
		if slot1.try_insert_item(item2):
			slot2.pickable_item = null
			if slot2.try_insert_item(item1):
				return true
			else:
				# no option now but to keep hold of item2
				print_debug(slot2.display_name, " couldn't accept ", item1.display_name)
				return false
		else:
			return false
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
