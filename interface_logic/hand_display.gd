extends Sprite2D

@export var control: Control
@export var label: Label
@export var tooltip: Label
@export var audio_player: AudioStreamPlayer

@export var audio_rejected: AudioStream

var tween: Tween

func _ready():
	control.visible = false
	label.text = ""
	tooltip.text = ""
	PlayerHand.item_reserved.connect(_on_PlayerHand_item_reserved)
	PlayerHand.item_placed.connect(_on_PlayerHand_item_placed)
	PlayerHand.item_dropped.connect(_on_PlayerHand_item_dropped)
	PlayerHand.item_rejected.connect(_on_PlayerHand_item_rejected)
	PlayerHand.hover_entered.connect(_on_PlayerHand_hover_entered)
	PlayerHand.hover_exited.connect(_on_PlayerHand_hover_exited)

func _process(delta):
	# follow mouse, round to pixel coords
	self.position = get_viewport().get_mouse_position().floor()
	
	update_tooltips()

func update_tooltips():
	var hovered_interactable = PlayerHand.hovered_interactable
	if hovered_interactable != null:
		control.visible = true
		label.text = hovered_interactable.display_name
		tooltip.text = hovered_interactable.tooltip
	else:
		control.visible = false
	
	if tooltip.text == "":
		tooltip.visible = false
	else:
		tooltip.visible = true


func _on_PlayerHand_item_reserved(item):
	if item is Ingredient:
		self.texture = item.texture
		audio_player.stream = item.audio_pickup
		audio_player.play()

func _on_PlayerHand_item_placed(item):
	self.texture = null
	if item is Ingredient:
		audio_player.stream = item.audio_drop
		audio_player.play()

func _on_PlayerHand_item_dropped(item):
	# TODO: animation for sprite returning to source
	self.texture = null
	if item is Ingredient:
		audio_player.stream = item.audio_drop
		audio_player.play()

func _on_PlayerHand_item_rejected(item):
	# little shake animation
	self.offset.x = -32
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "offset:x", 0, 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	audio_player.stream = audio_rejected
	audio_player.play()

# TODO: figure out if there is still a use for these, if labels need to be updated constantly anyway
func _on_PlayerHand_hover_entered(interactable: Interactable):
	pass

func _on_PlayerHand_hover_exited(interactable: Interactable):
	pass
