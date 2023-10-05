extends Node

class_name FreeplayController

@export var customer_scene: PackedScene
@export var dish_scene: PackedScene
@export var customers_dir: String

@export var dialogue_good: Dialogue
@export var dialogue_neutral: Dialogue
@export var dialogue_bad: Dialogue

@export var customers_per_day: int = 4

var day: int = 0

@export var customer_pool: Array[Customer]
var customers_in_line: Array[Customer]
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
					customer_pool.append(res)
		file_name = dir.get_next()
	
	# setup serving area
	var serving_dish_instance = dish_scene.instantiate()
	serving_dish = serving_dish_instance as ServingDish
	serving_dish.dish_served.connect(_on_dish_served)
	# TODO: need a better way to place this in the right position
	serving_dish.position = Vector2(188, 194)
	Game.world_root.add_child(serving_dish_instance)
	
	start_day()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_day():
	day += 1
	var pick_pool = customer_pool.duplicate()
	customers_in_line = []
	for i in range(customers_per_day):
		var pick = pick_pool.pick_random()
		customers_in_line.append(pick)
		pick_pool.erase(pick)
	
	next_customer()

func end_day():
	# TODO: GUI and/or animation
	start_day()

func next_customer():
	if customers_in_line.size() == 0:
		end_day()
		return
	if prop_customer == null:
		var customer_instance = customer_scene.instantiate()
		prop_customer = customer_instance as CustomerEffects
		prop_customer.entered.connect(_on_customer_entered)
		prop_customer.exited.connect(_on_customer_exited)
		prop_customer.position = Vector2(200, 80)
		Game.world_root.add_child(prop_customer)
	
	current_customer = customers_in_line.back()
	prop_customer.sprite.texture = current_customer.texture
	prop_customer.enter()
	Game.play_dialogue(current_customer.dialogue)

func end_customer():
	if prop_customer:
		prop_customer.exit()
	customers_in_line.erase(current_customer)
	current_customer = null

func stop():
	serving_dish.queue_free()
	prop_customer.queue_free()
	self.queue_free()

func _on_dish_served(dish_step, added_ingredients: Array):
	if current_customer == null:
		return
	var rating = current_customer.rate_dish(added_ingredients)
	if rating >= 1:
		Game.play_dialogue(dialogue_good)
	elif rating < 0:
		Game.play_dialogue(dialogue_bad)
	else:
		Game.play_dialogue(dialogue_neutral)
	
	# TODO: calling this immediately after the dialogue should queue a UI event to happen after the dialogue is finished
	# Actually, same with having the customer exit. Should be able to build up a queue of visual events, while letting all the game logic stuff happen immediately
	Player.add_money(10 * (rating + 1))
	
	# TODO: only do this after above dialog is finished
	Game.dialogue_player.dialogue_finished.connect(_on_eval_ended, CONNECT_ONE_SHOT)

func _on_eval_ended():
	end_customer()

func _on_customer_entered():
	pass

func _on_customer_exited():
	next_customer()
