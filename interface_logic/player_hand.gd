extends Node

var held_item: Ingredient

func _init():
	held_item = null

func player_pickup(item: Ingredient) -> bool:
	if held_item == null:
		held_item = item
		return true
	else:
		return false

func player_drop() -> Ingredient:
	if held_item != null:
		var temp = held_item
		held_item = null
		return temp
	else:
		return null
