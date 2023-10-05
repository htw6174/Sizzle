extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.register_menu("Main", self)
	PlayerHand.active = false


func _on_tutorial_pressed():
	self.visible = false
	PlayerHand.active = true
	Game.begin_tutorial()


func _on_play_pressed():
	self.visible = false
	PlayerHand.active = true
	Game.begin_freeplay()


func _on_options_pressed():
	Game.open_options()
