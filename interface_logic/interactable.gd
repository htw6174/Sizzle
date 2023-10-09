extends Area2D

class_name Interactable

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
	pass

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
