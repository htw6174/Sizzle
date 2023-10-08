extends Node2D

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
# TODO: hook these up again, could still be useful for visuals
signal hover_entered(interactable)
signal hover_exited(interactable)

func _init():
	hovered_interactable = null
	reserved_item = null

func _physics_process(delta):
	if active:
		# raycast to find hovered_interactable
		var mouse_pos = get_viewport().get_mouse_position()
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mouse_pos
		query.collide_with_areas = true
		# TODO: set collision mask
		# only need the first result for now
		var hits = space_state.intersect_point(query, 1)
		if hits.size() > 0:
			var hit = hits[0].collider
			if hit is Interactable:
				hovered_interactable = hit
			elif hit.get_parent() is Interactable:
				hovered_interactable = hit.get_parent()
			else:
				print_debug(hit.name)
				hovered_interactable = null
		else:
			hovered_interactable = null

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
	if event is InputEventScreenTouch:
		is_touch_input = true
		if event.index == 0:
			if event.pressed:
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
	#return # TEST: disable mouse input
	if event is InputEventMouseButton:
		is_touch_input = false
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
