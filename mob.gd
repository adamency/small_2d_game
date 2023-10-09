extends RigidBody2D

var swim_state = 0
var fly_orig_linear_velocity
var walk_timer
var walk_last_rotation

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]
	$AnimatedSprite2D.play()
	fly_orig_linear_velocity = linear_velocity
	walk_last_rotation = rotation
	if $AnimatedSprite2D.animation == mob_types[2]:
		walk_timer = Timer.new()
		add_child(walk_timer)
		walk_timer.set_wait_time(1.0)
		walk_timer.connect("timeout", _on_walk_timer_timeout)
		walk_timer.start()
#		_print_instance(["WALK TIMER IS STOPPED: ", walk_timer.is_stopped()])

func _process(delta):
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	if $AnimatedSprite2D.animation == mob_types[0]:
		process_fly(delta)
	if $AnimatedSprite2D.animation == mob_types[1]:
		process_swim(delta)
	if $AnimatedSprite2D.animation == mob_types[2]:
		process_walk(delta)
		
func process_fly(delta):
	linear_velocity = fly_orig_linear_velocity
	if randi() % 3 == 0:
		linear_velocity *= 1.2
	if randi() % 3 == 1:
		linear_velocity *= 1.5
	if randi() % 3 == 2:
		linear_velocity *= 2

# Lateral vibration
func process_swim(delta):
	var state_switcher = swim_state / 5
	if state_switcher % 3 == 0:
		position *= Vector2(1 + delta * 2,1)
	if state_switcher % 3 == 1:
		position *= Vector2(1,1)
	if state_switcher % 3 == 2:
		position *= Vector2(1,1 + delta * 2)
	swim_state += 1

func process_walk(delta):
	pass
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _on_walk_timer_timeout():
	#_print_instance("I TIMED OUT")
	var turn = PI / 2 * ((randi() % 2) * 2 - 1)
	rotation = walk_last_rotation + turn
	linear_velocity = linear_velocity.rotated(turn)
	walk_last_rotation = rotation

func _print_instance(args):
	var output = str(get_instance_id()) + " - "
	for arg in args:
		output += " " + str(arg)
	print(output)
