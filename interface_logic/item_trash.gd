extends ItemSlot

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, true)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	pickable_item = item
	item_sprite.texture = pickable_item.texture
	return true
