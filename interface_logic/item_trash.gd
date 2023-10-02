extends Interactable

var last_inserted_item: Ingredient

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	display_name = "Trash"

func try_insert_item(item: Ingredient) -> bool:
	if item != null:
		last_inserted_item = item
		display_name = "Trash ({0})".format([last_inserted_item.display_name])
		item_sprite.texture = last_inserted_item.texture
	return true

func try_reserve_item() -> Ingredient:
	if last_inserted_item != null:
		is_item_reserved = true
		item_reserved.emit(last_inserted_item)
		return last_inserted_item
	else:
		return null

func try_take_item() -> Ingredient:
	if last_inserted_item != null:
		var temp_item = last_inserted_item
		last_inserted_item = null
		display_name = "Trash"
		item_sprite.texture = null
		item_removed.emit(temp_item)
		return temp_item
	else:
		return null

func try_return_item() -> bool:
	if last_inserted_item != null:
		is_item_reserved = false
		item_returned.emit(last_inserted_item)
		return true
	else:
		return false
