extends Sprite

export(NodePath) var label_path
onready var label: Label = get_node(label_path)
export(NodePath) var audio_player_path
onready var audio_player: AudioStreamPlayer = get_node(audio_player_path)

func _ready():
	PlayerHand.connect("item_taken", self, "_on_PlayerHand_item_taken")
	PlayerHand.connect("item_dropped", self, "_on_PlayerHand_item_dropped")

func _process(delta):
	# follow mouse
	self.position = get_viewport().get_mouse_position()
	
	if is_instance_valid(PlayerHand.hovered_interactable):
		label.text = PlayerHand.hovered_interactable.display_name
	else:
		label.text = ""
	
	if PlayerHand.held_item != null:
		self.texture = PlayerHand.held_item.texture
		#self.visible = true
	else:
		self.texture = null
		#self.visible = false

func _on_PlayerHand_item_taken(item):
	if item is Ingredient:
		audio_player.stream = item.get_interact_audio_1()
		audio_player.play()

func _on_PlayerHand_item_dropped(item):
	if item is Ingredient:
		audio_player.stream = item.get_interact_audio_2()
		audio_player.play()
