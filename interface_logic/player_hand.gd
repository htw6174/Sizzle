extends Node

enum HandState {
	EMPTY,
	DRAGGING,
	HOLDING
}

var active: bool:
	set(value):
		if value:
			# TODO: might not register as hovering if mouse already over something when becoming active
			pass
		else:
			hovered_interactable = null
		active = value
	get:
		return active
var hovered_interactable: Interactable
var source_interactable: Interactable
var reserved_item: Ingredient

var state: HandState = HandState.EMPTY
var is_touch_input: bool = false

signal item_reserved(item)
signal item_placed(item)
signal item_dropped(item)
signal item_rejected(item)
signal hover_entered(interactable)
signal hover_exited(interactable)

func _init():
	hovered_interactable = null
	reserved_item = null

func try_pick():
	if hovered_interactable != null:
		reserved_item = hovered_interactable.try_reserve_item()
		if reserved_item != null:
			state = HandState.DRAGGING
			source_interactable = hovered_interactable
			item_reserved.emit(reserved_item)

func try_place():
	if hovered_interactable != null:
		if hovered_interactable.try_insert_item(reserved_item):
			var taken_item = source_interactable.try_take_item()
			assert(taken_item == reserved_item)
			item_placed.emit(reserved_item)
			state = HandState.EMPTY
			source_interactable = null
			reserved_item = null
		else:
			if hovered_interactable is ItemSlot && source_interactable is ItemSlot:
				if ItemSlot.try_swap_item(source_interactable, hovered_interactable):
					item_placed.emit(reserved_item)
					state = HandState.EMPTY
					source_interactable = null
					reserved_item = null
			else:
				item_rejected.emit(reserved_item)
				if state == HandState.DRAGGING:
					_drop()
	else:
		_drop()

func _drop():
	if source_interactable.try_return_item():
		item_dropped.emit(reserved_item)
		state = HandState.EMPTY
		source_interactable = null
		reserved_item = null

func handle_drop():
	if reserved_item != null:
		_drop()

func _unhandled_input(event):
	return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				match state:
					HandState.EMPTY:
						try_pick()
					HandState.DRAGGING:
						pass
					HandState.HOLDING:
						try_place()
			else:
				match state:
					HandState.EMPTY:
						pass
					HandState.DRAGGING:
						# cursor hasn't moved off of original interactable between press and release
						if source_interactable == hovered_interactable:
							state = HandState.HOLDING
						else:
							try_place()
					HandState.HOLDING:
						pass
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			handle_drop()

func _on_Interactable_mouse_entered(interactable: Interactable):
	if active:
		hovered_interactable = interactable
		hover_entered.emit(interactable)

func _on_Interactable_mouse_exited(interactable: Interactable):
	if active:
		if hovered_interactable == interactable:
			hovered_interactable = null
		hover_exited.emit(interactable)

func _on_Interactable_touched(interactable: Interactable, pressed: bool):
	if active:
		is_touch_input = true
		hovered_interactable = interactable
		hover_entered.emit(interactable)
		if pressed:
			match state:
				HandState.EMPTY:
					try_pick()
				HandState.DRAGGING:
					pass
				HandState.HOLDING:
					try_place()
		else:
			if state == HandState.DRAGGING:
				if source_interactable == hovered_interactable:
					state = HandState.HOLDING
				else:
					try_place()
