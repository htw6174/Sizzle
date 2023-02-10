extends Sprite

export(NodePath) var control_path
onready var control: Control = get_node(control_path)
export(NodePath) var label_path
onready var label: Label = get_node(label_path)
export(NodePath) var tooltip_path
onready var tooltip: Label = get_node(tooltip_path)
export(NodePath) var audio_player_path
onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)

var hovered_interactable: Interactable

func _ready():
	control.visible = false
	label.text = ""
	tooltip.text = ""
	PlayerHand.connect("item_taken", self, "_on_PlayerHand_item_taken")
	PlayerHand.connect("item_dropped", self, "_on_PlayerHand_item_dropped")
	PlayerHand.connect("hover_entered", self, "_on_PlayerHand_hover_entered")
	PlayerHand.connect("hover_exited", self, "_on_PlayerHand_hover_exited")

func _process(delta):
	# follow mouse
	self.position = get_viewport().get_mouse_position()
	
	if hovered_interactable:
		label.text = hovered_interactable.display_name
		tooltip.visible = true
		tooltip.text = hovered_interactable.tooltip
	else:
		label.text = ""
		tooltip.text = ""
	
	if tooltip.text == "":
		tooltip.visible = false

func _on_PlayerHand_item_taken(item):
	if item is Ingredient:
		self.texture = item.texture
		audio_player.stream = item.get_interact_audio_1()
		audio_player.play()

func _on_PlayerHand_item_dropped(item):
	self.texture = null
	if item is Ingredient:
		audio_player.stream = item.get_interact_audio_2()
		audio_player.play()

func _on_PlayerHand_hover_entered(interactable: Interactable):
	control.visible = true
	hovered_interactable = interactable

func _on_PlayerHand_hover_exited(interactable: Interactable):
	control.visible = false
	hovered_interactable = null
