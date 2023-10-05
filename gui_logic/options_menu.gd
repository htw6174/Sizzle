extends Control
class_name OptionsMenu

signal opened
signal closed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open():
	opened.emit()

func _on_close_pressed():
	closed.emit()

func _on_main_menu_pressed():
	closed.emit()
	Game.open_menu("Main")

func _on_opened():
	self.visible = true

func _on_closed():
	self.visible = false
