extends Node

class_name Interactable

signal mouse_entered(interactable)
signal mouse_exited(interactable)
signal touched(interactable, pressed: bool)
signal interacted(interactable)
signal item_inserted(item)
signal item_reserved(item)
signal item_removed(item)
signal item_returned(item)

## Always shown on mouseover, should limit to a single line of text < 40 characters
@export var display_name: String
@export var item_sprite: Sprite2D

var is_item_reserved: bool = false

## Often shown on mouseover, but not always. May be a multiline block of text
var tooltip: String = ""
var is_tooltip_hidden: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#mouse_entered.connect(PlayerHand._on_Interactable_mouse_entered)
	#mouse_exited.connect(PlayerHand._on_Interactable_mouse_exited)
	touched.connect(PlayerHand._on_Interactable_touched)

# *** Virtual: should override
func can_accept_item(item: Ingredient) -> bool:
	return item != null

func try_insert_item(item: Ingredient) -> bool:
	return false

func try_reserve_item() -> Ingredient:
	return null

func try_take_item() -> Ingredient:
	return null

func try_return_item() -> bool:
	return false
# ***

func _on_Area2D_mouse_entered():
	mouse_entered.emit(self)

func _on_Area2D_mouse_exited():
	mouse_exited.emit(self)

# Might want to change how all this is handled later; for now only care about touch events, mouse enter/exit is enough for mouse controls
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.index == 0:
			touched.emit(self, event.pressed)
