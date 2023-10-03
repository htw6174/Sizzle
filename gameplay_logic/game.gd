extends Node

var options_scene = preload("res://gui_logic/scenes/options_menu.tscn")
var freeplay_controller = preload("res://gameplay_logic/freeplay.tscn")
var dialogue_scene = preload("res://game_scenes/dialogue.tscn")
var recipe_book_scene = preload("res://gui_logic/scenes/recipe_book.tscn")
var recipe_selector_scene = preload("res://gui_logic/scenes/recipe_selector.tscn")

# Default nodes to use for instancing scenes
var world_root: Node
var gui_root: Node

var options_menu
var dialogue_player: DialoguePlayer
var recipe_book: RecipeBook
var recipe_selector: RecipeSelector

# Called when the node enters the scene tree for the first time.
func _ready():
	world_root = get_node("/root/Main/World")
	if world_root == null:
		world_root = self
	
	gui_root = get_node("/root/Main/GUI")
	if gui_root == null:
		gui_root = self
	
	# TODO: think about this as a design practice more. On one hand, makes it easier to setup scenes with access to "global" functionality
	# on the other hand, may cause weird errors when trying to test these scenes in isolation
	# At the very least, make a base "menu" class for some of the common behavior here
	dialogue_player = dialogue_scene.instantiate() as DialoguePlayer
	dialogue_player.dialogue_started.connect(_on_menu_opened)
	dialogue_player.dialogue_finished.connect(_on_menu_closed)
	dialogue_player.visible = false
	gui_root.add_child(dialogue_player)
	
	recipe_selector = recipe_selector_scene.instantiate() as RecipeSelector
	recipe_selector.opened.connect(_on_menu_opened)
	recipe_selector.closed.connect(_on_menu_closed)
	recipe_selector.visible = false
	gui_root.add_child(recipe_selector)
	
	recipe_book = recipe_book_scene.instantiate() as RecipeBook
	recipe_book.opened.connect(_on_menu_opened)
	recipe_book.closed.connect(_on_menu_closed)
	recipe_book.visible = false
	gui_root.add_child(recipe_book)
	
	options_menu = options_scene.instantiate() as OptionsMenu
	options_menu.opened.connect(_on_menu_opened)
	options_menu.closed.connect(_on_menu_closed)
	options_menu.visible = false
	gui_root.add_child(options_menu)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func open_options():
	options_menu.open()

func begin_tutorial():
	pass

func begin_freeplay():
	var fp = freeplay_controller.instantiate()
	self.add_child(fp)

func play_dialogue(dialogue: Dialogue):
	dialogue_player.start_dialogue(dialogue)

func open_recipe_book():
	recipe_book.open_ingredient_index()

func inspect_ingredient(ingredient: Ingredient):
	recipe_book.open_ingredient_details(ingredient)

## callable must have a single ProcessStep param TOOD figure out how to specify / require this
func prompt_recipe_selection(options: Array[ProcessStep], callable: Callable):
	recipe_selector.recipe_selected.connect(callable, CONNECT_ONE_SHOT)
	recipe_selector.present_options(options)

func _on_menu_opened():
	PlayerHand.active = false
	
func _on_menu_closed():
	PlayerHand.active = true
