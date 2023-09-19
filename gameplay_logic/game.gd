extends Node

var freeplay_controller = preload("res://gameplay_logic/freeplay.tscn")
var dialogue_scene = preload("res://game_scenes/dialogue.tscn")

var dialogue_player: DialoguePlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func begin_tutorial():
	pass

func begin_freeplay():
	var fp = freeplay_controller.instantiate()
	self.add_child(fp)

func play_dialogue(dialogue: Dialogue):
	if dialogue_player == null:
		var dp = dialogue_scene.instantiate()
		dialogue_player = dp as DialoguePlayer
		dialogue_player.dialogue_finished.connect(_on_dialogue_finished)
		self.add_child(dialogue_player)
	
	dialogue_player.start_dialogue(dialogue)
	PlayerHand.active = false
	

func _on_dialogue_finished():
	PlayerHand.active = true
