extends Node

class_name FreeplayController

@export var customer_scene: PackedScene
@export var dish_scene: PackedScene
@export var customers: Array[Customer]

var prop_customer: CustomerEffects = null
var serving_dish: ServingDish = null


# Called when the node enters the scene tree for the first time.
func _ready():
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
		prop_customer.position = Vector2(200, 100)
		self.add_child(prop_customer)
	
	var customer = customers.pick_random()
	prop_customer.enter()
	Game.play_dialogue(customer.dialogue)

func end_customer():
	if prop_customer:
		prop_customer.exit()

func _on_dish_served(dish_step, added_ingredients: Array):
	Player.add_money(added_ingredients.size() * 10)
	end_customer()

func _on_customer_entered():
	# TODO: play dialogue
	pass

func _on_customer_exited():
	next_customer()
