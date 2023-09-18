@icon("res://sprites/chef tutorial.png")
extends Resource
class_name Dialogue

@export var speaker_name: String
@export var portrait: Texture2D
@export_multiline var lines: Array[String]
