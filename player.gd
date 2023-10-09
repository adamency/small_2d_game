extends Area2D

signal hit

@export var speed = 400 # px/sec
var screen_size # Size of the Game Window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # player Movement Vector
	if Input.is_action_pressed("move_down"):
		velocity += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		velocity += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		velocity += Vector2(1, 0)
	if Input.is_action_pressed("move_up"):
		velocity += Vector2(0, -1)
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# ME
	$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y == 0:
		$AnimatedSprite2D.animation = "walk"
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
#	# THEM
#	if velocity.x != 0:
#		$AnimatedSprite2D.animation = "walk"
#		$AnimatedSprite2D.flip_v = false
#		$AnimatedSprite2D.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite2D.animation = "up"
#		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	position += velocity * delta
	
	# Get size of object to clamp to its boundaries instead of its center
	var hitbox = $CollisionShape2D.get_shape().get_rect().size / 2
	position = position.clamp(Vector2.ZERO + hitbox, screen_size - hitbox) # Replace with function body.

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _on_body_entered(body):
	hide()
	hit.emit()
	# Wait until after collision processing to disable the object's hitbox (see: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/03.coding_the_player.html#preparing-for-collisions)
	$CollisionShape2D.set_deferred("disabled", true)
