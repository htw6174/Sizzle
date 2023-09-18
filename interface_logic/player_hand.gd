extends Node

var hovered_interactable: Interactable
var source_interactable: Interactable
var reserved_item: Ingredient

signal item_reserved(item)
signal item_placed(item)
signal item_dropped(item)
signal hover_entered(interactable)
signal hover_exited(interactable)

func _init():
	hovered_interactable = null
	reserved_item = null

func try_pick():
	reserved_item = hovered_interactable.try_reserve_item()
	if reserved_item != null:
		source_interactable = hovered_interactable
		emit_signal("item_reserved", reserved_item)

func try_place():
	if hovered_interactable.try_insert_item(reserved_item):
		var taken_item = source_interactable.try_take_item()
		assert(taken_item == reserved_item)
		emit_signal("item_placed", reserved_item)
		source_interactable = null
		reserved_item = null
	else:
		if Interactable.try_swap_item(source_interactable, hovered_interactable):
			emit_signal("item_placed", reserved_item)
			source_interactable = null
			reserved_item = null

func drop():
	if source_interactable.try_return_item():
		emit_signal("item_dropped", reserved_item)
		source_interactable = null
		reserved_item = null

func handle_press():
	if reserved_item != null:
		if hovered_interactable != null:
			try_place()
		else:
			drop()
	else:
		if hovered_interactable != null:
			try_pick()

func handle_release():
	if source_interactable == hovered_interactable:
		# user hasn't moved the mouse to a new interactable, implying this not a click+drag interaction. Pass so that single clicks don't immediately drop
		pass
	else:
		if reserved_item != null:
			if hovered_interactable != null:
				try_place()
			else:
				drop()

func handle_drop():
	if reserved_item != null:
		drop()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				handle_press()
			else:
				handle_release()
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			handle_drop()

func _on_Interactable_mouse_entered(interactable: Interactable):
	hovered_interactable = interactable
	emit_signal("hover_entered", interactable)

func _on_Interactable_mouse_exited(interactable: Interactable):
	if hovered_interactable == interactable:
		hovered_interactable = null
	emit_signal("hover_exited", interactable)
