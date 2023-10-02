@tool
extends Interactable

@export var pickable_item: Ingredient:
	get:
		return pickable_item
	set(value):
		pickable_item = value
		if pickable_item:
			display_name = pickable_item.display_name
			item_sprite.texture = pickable_item.texture
		else:
			item_sprite.texture = null

func _ready():
	if Engine.is_editor_hint():
		pass
	else:
		super()

func can_accept_item(item: Ingredient) -> bool:
	return false

func try_insert_item(item: Ingredient) -> bool:
	return false

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		item_reserved.emit(pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		item_removed.emit(pickable_item)
		return pickable_item
	else:
		return null

func try_return_item() -> bool:
	if pickable_item != null:
		is_item_reserved = false
	return true

