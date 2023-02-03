extends Interactable

# Called when the node enters the scene tree for the first time.
func _ready():
	display_name = "Trash"

func handle_interaction():
	PlayerHand.notify_interaction(self, pickable_item, true)

func notify_item_taken(item: Ingredient):
	pickable_item = null
	display_name = "Trash"
	item_sprite.texture = null

func try_insert_item(item: Ingredient) -> bool:
	if item != null:
		pickable_item = item
		display_name = "Trash ({0})".format([pickable_item.display_name])
		item_sprite.texture = pickable_item.texture
	return true
