extends Node

var freeplay_controller = preload("res://gameplay_logic/freeplay.tscn")
var dialogue_scene = preload("res://game_scenes/dialogue.tscn")
var recipe_book_scene = preload("res://gui_logic/scenes/recipe_book.tscn")

# Default nodes to use for instancing scenes
var world_root: Node
var gui_root: Node

var dialogue_player: DialoguePlayer
var recipe_book: RecipeBook

# Called when the node enters the scene tree for the first time.
func _ready():
	world_root = get_node("/root/Main/World")
	if world_root == null:
		world_root = self
	
	gui_root = get_node("/root/Main/GUI")
	if gui_root == null:
		gui_root = self
	
	var dp = dialogue_scene.instantiate()
	dialogue_player = dp as DialoguePlayer
	dialogue_player.dialogue_finished.connect(_on_dialogue_finished)
	dialogue_player.visible = false
	gui_root.add_child(dialogue_player)
	
	# TODO: think about this as a design practice more. On one hand, makes it easier to setup scenes with access to "global" functionality
	# on the other hand, may cause weird errors when trying to test these scenes in isolation
	var rb = recipe_book_scene.instantiate()
	recipe_book = rb as RecipeBook
	recipe_book.opened.connect(_on_book_opened)
	recipe_book.closed.connect(_on_book_closed)
	recipe_book.visible = false
	gui_root.add_child(recipe_book)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func begin_tutorial():
	pass

func begin_freeplay():
	var fp = freeplay_controller.instantiate()
	self.add_child(fp)

func play_dialogue(dialogue: Dialogue):
	dialogue_player.start_dialogue(dialogue)
	PlayerHand.active = false

func open_recipe_book():
	recipe_book.visible = true
	recipe_book.close_ingredient_details()
	recipe_book.open_ingredient_index()

func inspect_ingredient(ingredient: Ingredient):
	# TODO: open recipe book, display info page for ingredient
	recipe_book.open_ingredient_details(ingredient)

func _on_dialogue_finished():
	PlayerHand.active = true

func _on_book_opened():
	PlayerHand.active = false

func _on_book_closed():
	PlayerHand.active = true
