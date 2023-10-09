extends Node
class_name TutorialController

@export var dish_scene: PackedScene

@export var dialogues: Array[String] # last should be a closing note
@export var portrait: Texture2D
@export var active_ingredient_group: String

var serving_dish: ServingDish = null

var tutorial_step: int = 0
var step_count: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	# setup serving area
	serving_dish = dish_scene.instantiate() as ServingDish
	serving_dish.dish_served.connect(_on_dish_served)
	# TODO: need a better way to place this in the right position
	serving_dish.position = Vector2(188, 194)
	Game.world_root.add_child(serving_dish)
	
	next_step()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_step():
	Game.play_dialogue(dialogues[tutorial_step], "TUTORIAL", portrait)
	if tutorial_step >= step_count:
		tutorial_step = 0
		Game.dialogue_player.dialogue_finished.connect(_on_final_dialogue_finished, CONNECT_ONE_SHOT)
	else:
		tutorial_step += 1

func stop():
	serving_dish.queue_free()
	self.queue_free()

func _on_dish_served(dish_step: DishStep, added_ingredients: Array[Ingredient]):
	next_step()

func _on_final_dialogue_finished():
	Game.open_menu("Main")
