extends ItemSlot

func handle_interaction():
	var held_item = PlayerHand.player_drop()
	if held_item != null:
		pickable_item = held_item
		item_sprite.texture = pickable_item.texture
	else:
		take_item()
