extends Control

@export var cursor_widget: Control
@export var cursor_icon: TextureRect
@export var cursor_panel: Control
@export var cursor_label: Label
@export var cursor_tooltip: Label

@export var touch_widget: Control
@export var touch_icon: TextureRect
@export var touch_label: Label
@export var touch_tooltip: Label

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
	touch_tooltip.visible = touch_tooltip.text != ""
	cursor_icon.visible = PlayerHand.state == PlayerHand.HandState.DRAGGING
	if PlayerHand.reserved_item != null:
		touch_label.text = PlayerHand.reserved_item.display_name
	if PlayerHand.state == PlayerHand.HandState.DRAGGING and PlayerHand.hovered_interactable != null:
		touch_tooltip.text = ": %s" % PlayerHand.hovered_interactable.display_name

func _on_PlayerHand_item_reserved(item):
	if item is Ingredient:
		cursor_icon.texture = item.texture
		touch_icon.texture = item.texture
		audio_player.stream = item.audio_pickup
		audio_player.play()

func _on_PlayerHand_item_placed(item):
	cursor_icon.texture = null
	touch_icon.texture = null
	if item is Ingredient:
		audio_player.stream = item.audio_drop
		audio_player.play()

func _on_PlayerHand_item_dropped(item):
	# TODO: animation for sprite returning to source
	cursor_icon.texture = null
	touch_icon.texture = null
	if item is Ingredient:
		audio_player.stream = item.audio_drop
		audio_player.play()

func _on_PlayerHand_item_rejected(item):
	var shake_node: Control
	if PlayerHand.is_touch_input:
		shake_node = cursor_icon
	else:
		shake_node = touch_widget
	
	var start_pos = shake_node.position.x
	# little shake animation
	# FIXME no shakey
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
