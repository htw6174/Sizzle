extends Control

@export var cursor_widget: Control
@export var cursor_icon: Sprite2D
@export var cursor_panel: Control
@export var cursor_label: Label
@export var cursor_tooltip: Label

@export var touch_widget: Control
@export var touch_icon: TextureRect
@export var touch_label: Label
@export var touch_tooltip: Label

@onready var touch_widget_orig_x = touch_widget.position.x

@export var audio_player: AudioStreamPlayer
@export var audio_rejected: AudioStream

var tween: Tween

func _ready():
	cursor_panel.visible = false
	cursor_label.text = ""
	cursor_tooltip.text = ""
	touch_label.text = ""
	touch_tooltip.text = ""
	PlayerHand.item_reserved.connect(_on_PlayerHand_item_reserved)
	PlayerHand.item_placed.connect(_on_PlayerHand_item_placed)
	PlayerHand.item_dropped.connect(_on_PlayerHand_item_dropped)
	PlayerHand.item_rejected.connect(_on_PlayerHand_item_rejected)
	PlayerHand.hover_entered.connect(_on_PlayerHand_hover_entered)
	PlayerHand.hover_exited.connect(_on_PlayerHand_hover_exited)

func _process(delta):
	# follow mouse, round to pixel coords
	cursor_widget.position = get_viewport().get_mouse_position().floor()
	
	touch_widget.visible = PlayerHand.is_touch_input and PlayerHand.state != PlayerHand.HandState.EMPTY
	cursor_panel.visible = !PlayerHand.is_touch_input
	if PlayerHand.is_touch_input:
		update_touch_widget()
	else:
		update_cursor_widget()

func update_cursor_widget():
	cursor_tooltip.visible = cursor_tooltip.text != ""
	var hovered_interactable = PlayerHand.hovered_interactable
	if hovered_interactable != null:
		cursor_panel.visible = true
		cursor_label.text = hovered_interactable.display_name
		cursor_tooltip.text = hovered_interactable.tooltip
	else:
		cursor_panel.visible = false

func update_touch_widget():
	#cursor_icon.visible = PlayerHand.state == PlayerHand.HandState.DRAGGING
	if PlayerHand.reserved_item != null:
		touch_label.text = PlayerHand.reserved_item.display_name
	elif PlayerHand.state == PlayerHand.HandState.EMPTY and PlayerHand.hovered_interactable != null:
		touch_widget.visible = true
		touch_icon.texture = null
		touch_label.text = PlayerHand.hovered_interactable.display_name
		touch_tooltip.text = PlayerHand.hovered_interactable.tooltip
	if PlayerHand.state == PlayerHand.HandState.DRAGGING and PlayerHand.hovered_interactable != null:
		touch_tooltip.text = "to %s" % PlayerHand.hovered_interactable.display_name
	else:
		touch_tooltip.text = ""
	touch_tooltip.visible = touch_tooltip.text != ""

func _on_PlayerHand_item_reserved(item: Ingredient, source: Interactable):
	# ensure animations for other actions don't interfere
	if tween:
		tween.kill()
	cursor_icon.position = Vector2(0, 0)
	cursor_icon.texture = item.texture
	touch_icon.texture = item.texture
	audio_player.stream = item.audio_pickup
	audio_player.play()

func _on_PlayerHand_item_placed(item: Ingredient, placed_in: Interactable):
	cursor_icon.texture = null
	touch_icon.texture = null
	audio_player.stream = item.audio_drop
	audio_player.play()

func _on_PlayerHand_item_dropped(item: Ingredient, source: Interactable):
	# TODO: animation for sprite returning to source
	touch_icon.texture = null
	audio_player.stream = item.audio_drop
	audio_player.play()
	
	# return to origin animation
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(cursor_icon, "global_position", source.global_position, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	# TODO: chain to end of tween
	tween.tween_callback(cursor_icon.set_texture.bind(null))
	#cursor_icon.texture = null

func _on_PlayerHand_item_rejected(item: Ingredient, rejected_from: Interactable):
	# FIXME: doesn't do this effect if rejected from end of drag
	var shake_node: CanvasItem
	var start_pos = 0
	if PlayerHand.is_touch_input:
		shake_node = touch_widget
		start_pos = touch_widget_orig_x
	else:
		shake_node = cursor_icon
	
	# little shake animation
	shake_node.position.x -= 32
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(shake_node, "position:x", start_pos, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	audio_player.stream = audio_rejected
	audio_player.play()

# TODO: figure out if there is still a use for these, if labels need to be updated constantly anyway
func _on_PlayerHand_hover_entered(interactable: Interactable):
	pass

func _on_PlayerHand_hover_exited(interactable: Interactable):
	pass
