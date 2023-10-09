extends Control

class_name DialoguePlayer

@export var start_animation: String
@export var finish_animation: String

@export var _portrait: TextureRect
@export var _animation_player: AnimationPlayer
@export var _name_label: Label
@export var _dialogue_label: RichTextLabel

var current_key: String
var dialogue_index: int = 0

signal dialogue_started
signal dialogue_finished

func _ready():
	pass

func start_dialogue(key: String, speaker: String = "", portrait: Texture2D = null):
	current_key = key
	# portrait
	_portrait.texture = portrait
	
	# name
	_name_label.text = tr(key) if speaker == "" else tr(speaker)
	
	# text
	dialogue_index = 0
	advance_dialogue()
	
	self.visible = true
	_animation_player.play(start_animation)
	dialogue_started.emit()

# display single line
func show_text(key: String, speaker: String = "", portrait: Texture2D = null):
	# portrait
	_portrait.texture = portrait
	
	# name
	if speaker != "":
		_name_label.text = tr(speaker)
	else:
		_name_label.visible = false
	
	# text
	_dialogue_label.text = tr(key)
	
	self.visible = true
	_animation_player.play(start_animation)
	dialogue_started.emit()

func advance_dialogue():
	dialogue_index += 1
	var line_key = "{0}.{1}".format([current_key, dialogue_index])
	var translation = tr(line_key)
	if translation == line_key:
		finish_dialogue()
	else:
		_dialogue_label.text = translation

func finish_dialogue():
	_animation_player.play(finish_animation)
	current_key = ""
	dialogue_index = 0

func skip_dialogue():
	finish_dialogue()

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		advance_dialogue()

func _on_AnimationPlayer_animation_finished(anim_name: String):
	if anim_name == finish_animation:
		self.visible = false
		dialogue_finished.emit()


func _on_SkipButton_pressed():
	skip_dialogue()
