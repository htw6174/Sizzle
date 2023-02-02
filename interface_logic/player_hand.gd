extends Node

var held_item: Ingredient

func _init():
	held_item = null
		
func notify_interaction(interactable: ItemSlot, available_item: Ingredient, can_accept_item: bool):
	if held_item == null and available_item != null:
		held_item = available_item
		interactable.notify_item_taken(available_item)
	else:
		if interactable.try_insert_item(held_item):
			held_item = null
