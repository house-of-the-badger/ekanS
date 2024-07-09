class_name Mouse extends CharacterBody2D

signal spawn_mouse


const SPEED = 75

var motion = Vector2()
var gravity = 0
var direction = 0
var last_position: Vector2
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	gravity = generate_random_sign()
	direction = generate_random_sign()

func _physics_process(delta):
	motion.y += gravity
	motion.x = SPEED * direction
	move_and_collide(motion * delta)
	if is_outside_viewport():
		queue_free()  #Despawns the mouse if it's outside the viewport

func generate_random_sign() -> int:
	return (rng.randi() % 2) * 2 - 1

func is_outside_viewport() -> bool:
	var viewport = get_viewport()
	var viewport_rect = viewport.get_visible_rect()
	return !viewport_rect.has_point(position)
