extends Sprite2D

@export var control_path: NodePath
@onready var control: Control = get_node(control_path)
@export var label_path: NodePath
@onready var label: Label = get_node(label_path)
@export var tooltip_path: NodePath
@onready var tooltip: Label = get_node(tooltip_path)
@export var audio_player_path: NodePath
@onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)

func _ready():
	control.visible = false
	label.text = ""
	tooltip.text = ""
	PlayerHand.item_reserved.connect(_on_PlayerHand_item_reserved)
	PlayerHand.item_placed.connect(_on_PlayerHand_item_placed)
	PlayerHand.item_dropped.connect(_on_PlayerHand_item_dropped)
	PlayerHand.hover_entered.connect(_on_PlayerHand_hover_entered)
	PlayerHand.hover_exited.connect(_on_PlayerHand_hover_exited)

func _process(delta):
	# follow mouse
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
		audio_player.stream = item.get_interact_audio_1()
		audio_player.play()

func _on_PlayerHand_item_placed(item):
	self.texture = null
	if item is Ingredient:
		audio_player.stream = item.get_interact_audio_2()
		audio_player.play()

func _on_PlayerHand_item_dropped(item):
	# TODO: animation for sprite returning to source
	self.texture = null
	if item is Ingredient:
		audio_player.stream = item.get_interact_audio_2()
		audio_player.play()

# TODO: figure out if there is still a use for these, if labels need to be updated constantly anyway
func _on_PlayerHand_hover_entered(interactable: Interactable):
	pass

func _on_PlayerHand_hover_exited(interactable: Interactable):
	pass
