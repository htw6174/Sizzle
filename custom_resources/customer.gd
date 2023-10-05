extends Resource
class_name Customer

@export var texture: Texture2D
@export var dialogue: Dialogue
@export var request: Array[Ingredient]
@export var loves: Array[Ingredient]
@export var hates: Array[Ingredient]

func rate_dish(ingredients: Array[Ingredient]) -> int:
	var rating = 0
	
	var loves_count = 0
	var hates_count = 0
	
	# Were any requested items missed? Also count loves/hates
	var request_missed = request.duplicate()
	for ingredient in ingredients:
		if request_missed.has(ingredient):
			request_missed.erase(ingredient)
		if loves.has(ingredient): loves_count += 1
		if hates.has(ingredient): hates_count += 1
	var miss_count = request_missed.size()
	
	var frac_missing: float
	# Avoid div0
	if request.size() > 0:
		frac_missing = miss_count as float / request.size()
	else:
		frac_missing = 0
	
	# TODO: more interesting algo. For now make it super simple
	if ingredients.size() == 0:
		rating -= 1
	if request.size() > 0 && miss_count == 0:
		rating += 1
	if miss_count > 0:
		rating -= miss_count
#	if loves_count > 0:
#		rating += 1
#	if hates_count > 0:
#		rating -= 1
	# Alternatively,
	rating += loves_count
	rating -= hates_count
	
	return rating
