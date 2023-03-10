extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	display_name = "Trash"

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		display_name = "Trash"
		item_sprite.texture = null
		emit_signal("item_reserved", pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		var temp_item = pickable_item
		pickable_item = null
		display_name = "Trash"
		item_sprite.texture = null
		emit_signal("item_removed", temp_item)
		return temp_item
	else:
		return null

func try_insert_item(item: Ingredient) -> bool:
	if item != null:
		pickable_item = item
		display_name = "Trash ({0})".format([pickable_item.display_name])
		item_sprite.texture = pickable_item.texture
	return true
