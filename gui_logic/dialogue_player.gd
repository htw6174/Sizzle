extends Node

class_name DialoguePlayer

@export var start_animation: String
@export var finish_animation: String

@export var animation_player_path: NodePath
@onready var animation_player:AnimationPlayer = get_node(animation_player_path)
@export var dialogue_label_path: NodePath
@onready var dialogue_label: RichTextLabel = get_node(dialogue_label_path)

var current_dialogue: Dialogue
var dialogue_index: int = 0

signal dialogue_finished

func _ready():
	#animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	pass

func start_dialogue(new_dialogue: Dialogue):
	current_dialogue = new_dialogue
	dialogue_index = 0
	dialogue_label.text = current_dialogue.lines[dialogue_index]
	self.visible = true
	animation_player.play(start_animation)

func advance_dialogue():
	if current_dialogue != null:
		dialogue_index += 1
		if dialogue_index >= current_dialogue.lines.size():
			finish_dialogue()
		else:
			dialogue_label.text = current_dialogue.lines[dialogue_index]

func finish_dialogue():
	animation_player.play(finish_animation)
	current_dialogue = null
	dialogue_index = 0

func skip_dialogue():
	finish_dialogue()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		advance_dialogue()

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == finish_animation:
		self.visible = false
		emit_signal("dialogue_finished")


func _on_SkipButton_pressed():
	skip_dialogue()
