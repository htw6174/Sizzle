extends Node

var held_item: Ingredient

func _init():
	held_item = null

func player_pickup(item: Ingredient):
	held_item = item
	
func player_drop() -> Ingredient:
	var temp = held_item
	held_item = null
	return temp
