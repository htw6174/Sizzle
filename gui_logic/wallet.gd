extends Control

@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = "{0}".format([Player.money])
	Player.money_added.connect(_on_money_added)
	Player.money_subtracted.connect(_on_money_subtracted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_money_added(value: int):
	label.text = "{0}".format([Player.money])

func _on_money_subtracted(value: int):
	label.text = "{0}".format([Player.money])
