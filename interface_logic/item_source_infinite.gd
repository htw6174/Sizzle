extends Interactable

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, false)

func notify_item_taken(item: Ingredient):
	# TODO: animation for taking item here
	pass

func try_insert_item(item: Ingredient) -> bool:
	return false

