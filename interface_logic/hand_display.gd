extends Sprite

export(NodePath) var control_path
onready var control: Control = get_node(control_path)
export(NodePath) var label_path
onready var label: Label = get_node(label_path)
export(NodePath) var tooltip_path
onready var tooltip: Label = get_node(tooltip_path)
export(NodePath) var audio_player_path
onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)

func _ready():
	control.visible = false
	label.text = ""
	tooltip.text = ""
	PlayerHand.connect("item_reserved", self, "_on_PlayerHand_item_reserved")
	PlayerHand.connect("item_placed", self, "_on_PlayerHand_item_placed")
	PlayerHand.connect("item_dropped", self, "_on_PlayerHand_item_dropped")
	PlayerHand.connect("hover_entered", self, "_on_PlayerHand_hover_entered")
	PlayerHand.connect("hover_exited", self, "_on_PlayerHand_hover_exited")

func _process(delta):
	# follow mouse
	self.position = get_viewport().get_mouse_position()
	
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
