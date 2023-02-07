extends Node

var hovered_interactable: Interactable
var held_item: Ingredient

func _init():
	hovered_interactable = null
	held_item = null

func notify_interactable_entered(interactable: Interactable):
	hovered_interactable = interactable

func notify_interactable_exited(interactable: Interactable):
	if hovered_interactable == interactable:
		hovered_interactable = null

func notify_interaction(interactable: Interactable, available_item: Ingredient, can_accept_item: bool):
	if held_item == null and available_item != null:
		held_item = available_item
		interactable.notify_item_taken(available_item)
	else:
		if can_accept_item:
			if interactable.try_insert_item(held_item):
				held_item = null
