extends CharacterBody2D

@export var move_speed: float = 160
@export var body_sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var move_velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		move_velocity.x -= 1.0
	if Input.is_action_pressed("move_right"):
		move_velocity.x += 1.0
	if Input.is_action_pressed("move_up"):
		move_velocity.y -= 1.0
	if Input.is_action_pressed("move_down"):
		move_velocity.y += 1.0
	
	if move_velocity.length() > 0.1:
		velocity = move_velocity * move_speed * delta
		body_sprite.play("walk")
		if abs(move_velocity.x) > 0.1:
			body_sprite.scale.x = sign(move_velocity.x)
	else:
		velocity = Vector2.ZERO
		body_sprite.pause()
	
	move_and_slide()
