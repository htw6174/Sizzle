extends Node2D
class_name CustomerEffects

@export var animation_player: AnimationPlayer

signal entered()
signal exited()

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_player.play("enter")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func enter():
	animation_player.play("enter")

func exit():
	animation_player.play("exit")
