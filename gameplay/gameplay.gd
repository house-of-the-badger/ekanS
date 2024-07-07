class_name Gameplay extends Node2D #inherits from Node2D

signal decrease_snake_length

const gameover_scene:PackedScene = preload("res://UI/game_over_UI.tscn")
const pausemenu_scene:PackedScene = preload("res://UI/pause_menu_UI.tscn")
var tail_scene:PackedScene = preload("res://gameplay/tail.tscn")


@export var textures:Array[Texture]
@onready var head: Head = %Head as Head 
#@onready var tail: Tail = %Tail as Tail
@onready var bounds: Bounds = %Bounds as Bounds
@onready var spawner: Spawner = %Spawner as Spawner
@onready var hud = $HUD
@onready var camera_2d = $Camera2D

const DIRECTION_RIGHT = Vector2.RIGHT
const DIRECTION_LEFT = Vector2.LEFT
const DIRECTION_UP = Vector2.UP
const DIRECTION_DOWN = Vector2.DOWN

const ROTATION_RIGHT: float = 90.0
const ROTATION_LEFT: float = 270.0
const ROTATION_UP: float = 0.0
const ROTATION_DOWN: float = 180.0

var move_dir: Vector2 = Vector2.UP
var rotation_map = {
	DIRECTION_RIGHT: ROTATION_RIGHT,
	DIRECTION_LEFT: ROTATION_LEFT,
	DIRECTION_UP: ROTATION_UP,
	DIRECTION_DOWN: ROTATION_DOWN
}
#@onready var snake_parts: SnakeParts = %SnakeParts as SnakeParts
#@onready var snakebody = %snakebody
#@onready var tail = $Tail

#@onready var snake_parts: SnakeParts = %SnakeParts as SnakeParts
#@onready var snakebody = %snakebody


#set interval between snake movement
var time_between_moves:float = 1000.0
var time_since_last_move:float = 0
var speed:float = 2000.0
var pooping_speed = 10
# sets moving direction at start of game. most game start moving left to right, I changed it to up becasue it's for mobile phone

var next_move_dir:Vector2 = Vector2.UP
#var head = snake_parts[0]
var snake_parts:Array[SnakeParts] = []
var moves_counter:int = 0
var pause_menu:PauseMenu
var gameover_menu:GameOver
var score:int:
	get: #getters and setters, research
		return score
	set(value):
		score = value
		hud.update_score(value)

func _ready() -> void:
	camera_2d.swipe_right.connect(_on_swipe.bind(DIRECTION_RIGHT))
	camera_2d.swipe_left.connect(_on_swipe.bind(DIRECTION_LEFT))
	camera_2d.swipe_up.connect(_on_swipe.bind(DIRECTION_UP))
	camera_2d.swipe_down.connect(_on_swipe.bind(DIRECTION_DOWN))
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	time_since_last_move = time_between_moves
	snake_parts.push_front(head) # tutorial was using push_back, but I think this is more correct? research
	initialize_snake()
	spawner.spawn_food()
	spawner.spawn_enemy()
	
	
func _on_swipe(direction: Vector2):
	if move_dir != -direction:
		next_move_dir = direction
		head.rotation_degrees = rotation_map[direction]
	
func initialize_snake():
		spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position)


func _process(_delta) -> void: #not sure I know what this void is
	if Input.is_action_just_pressed("ui_up"):
		_on_swipe(DIRECTION_UP)
	elif Input.is_action_just_pressed("ui_down"):
		_on_swipe(DIRECTION_DOWN)
	elif Input.is_action_just_pressed("ui_left"):
		_on_swipe(DIRECTION_LEFT)
	elif Input.is_action_just_pressed("ui_right"):
		_on_swipe(DIRECTION_RIGHT)
	if Input.is_action_just_pressed("ui_cancel"):
		pause_game()

#snake is made of area2d nodes, and area2d are physics, we use a physics process loop
func _physics_process(delta: float) -> void:
	#this sets an interval between movements, so it's not continuous
	time_since_last_move += delta * speed
	if time_since_last_move >= time_between_moves:
		update_snake()
		time_since_last_move = 0

func update_snake():
	#snake moves on it's own
	#change snake direction:
	move_dir = next_move_dir
	var new_position:Vector2 = head.position + move_dir * Global.CELL_SIZE #size of grid cell, set in global script
	new_position = bounds.wrap_vector(new_position)
	head.move_to(new_position) 
	for i in range(1, snake_parts.size(), 1):
		snake_parts[i].move_to(snake_parts[i-1].last_position) # this ensures that the tail follows the head
	moves_counter += 1
	if(moves_counter % pooping_speed == 0):
		score += 1
		detach_tail()
		speed += 300
	if(snake_parts.size() <= 1): # waiting for win scene
		Global.current_level = "level" + str(int(Global.current_level) + 1)
		if not gameover_menu:
			gameover_menu = gameover_scene.instantiate() as GameOver
			add_child(gameover_menu)
			gameover_menu.set_score(score)
	
	
func _on_food_eaten():
	detach_tail()
	spawner.call_deferred("spawn_food")
	speed += 300.0
	score += 10
	

func detach_tail():
	if (snake_parts.size() > 1):
		var new_poop = snake_parts.pop_back()
		decrease_snake_length.emit()
		new_poop.get_node("Sprite2D").texture = textures[0]
	

func _on_tail_added(tail:Tail):
		snake_parts.push_back(tail)

func _on_tail_collided():
	if not gameover_menu:
		gameover_menu = gameover_scene.instantiate() as GameOver
		add_child(gameover_menu)
		gameover_menu.set_score(score)

func _notification(what):
	if what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		pause_game()

func pause_game():
	if not pause_menu && not gameover_menu:
		pause_menu = pausemenu_scene.instantiate() as PauseMenu
		add_child(pause_menu)


func _on_head_prune_eaten():
	for i in 3:
		detach_tail()
	score += 20
	speed += 300

func _on_timer_timeout():
	if (Levels.Database[Global.current_level].has_prunes):
		spawner.call_deferred("spawn_prune")
	

func _on_hud_decrease_snake_length():
	hud.decrease_snake_length()

