extends Interactable

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func can_accept_item(item: Ingredient) -> bool:
	return false

func try_insert_item(item: Ingredient) -> bool:
	return false

func try_reserve_item() -> Ingredient:
	if pickable_item != null:
		is_item_reserved = true
		emit_signal("item_reserved", pickable_item)
		return pickable_item
	else:
		return null

func try_take_item() -> Ingredient:
	if pickable_item != null:
		emit_signal("item_removed", pickable_item)
		return pickable_item
	else:
		return null

func try_return_item() -> bool:
	if pickable_item != null:
		is_item_reserved = false
	return true

