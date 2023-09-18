extends Node

class_name FreeplayController

@export var customer_scene: PackedScene
@export var dish_scene: PackedScene
@export var customers_dir: String

@export var dialogue_good: Dialogue
@export var dialogue_neutral: Dialogue
@export var dialogue_bad: Dialogue

var customers: Array[Customer]
var current_customer: Customer

var prop_customer: CustomerEffects = null
var serving_dish: ServingDish = null


# Called when the node enters the scene tree for the first time.
func _ready():
	# load customer resources
	var dir = DirAccess.open(customers_dir)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			var res = load(customers_dir + file_name)
			if res != null:
				if res is Customer:
					customers.append(res)
		file_name = dir.get_next()
	
	# setup serving area
	var serving_dish_instance = dish_scene.instantiate()
	self.add_child(serving_dish_instance)
	serving_dish = serving_dish_instance as ServingDish
	serving_dish.dish_served.connect(_on_dish_served)
	# TODO: need a better way to place this in the right position
	serving_dish.position = Vector2(188, 194)
	
	next_customer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func next_customer():
	if prop_customer == null:
		var customer_instance = customer_scene.instantiate()
		prop_customer = customer_instance as CustomerEffects
		prop_customer.entered.connect(_on_customer_entered)
		prop_customer.exited.connect(_on_customer_exited)
		prop_customer.position = Vector2(200, 80)
		self.add_child(prop_customer)
	
	current_customer = customers.pick_random()
	prop_customer.sprite.texture = current_customer.texture
	prop_customer.enter()
	Game.play_dialogue(current_customer.dialogue)

func end_customer():
	if prop_customer:
		prop_customer.exit()
	current_customer = null

func _on_dish_served(dish_step, added_ingredients: Array):
	var rating = current_customer.rate_dish(added_ingredients)
	if rating >= 2:
		Game.play_dialogue(dialogue_good)
	elif rating < 0:
		Game.play_dialogue(dialogue_bad)
	else:
		Game.play_dialogue(dialogue_neutral)
	
	# TODO: calling this immediately after the dialogue should queue a UI event to happen after the dialogue is finished
	# Actually, same with having the customer exit. Should be able to build up a queue of visual events, while letting all the game logic stuff happen immediately
	Player.add_money(10 * (rating + 1))
	
	# TODO: only do this after above dialog is finished
	Game.dialogue_player.dialogue_finished.connect(_on_eval_ended)

func _on_eval_ended():
	Game.dialogue_player.dialogue_finished.disconnect(_on_eval_ended)
	end_customer()

func _on_customer_entered():
	pass

func _on_customer_exited():
	next_customer()
