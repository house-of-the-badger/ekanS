class_name Gameplay extends Node2D #inherits from Node2D

signal decrease_snake_length

const gameover_scene:PackedScene = preload("res://UI/game_over_UI.tscn")
const pausemenu_scene:PackedScene = preload("res://UI/pause_menu_UI.tscn")
var tail_scene:PackedScene = preload("res://gameplay/tail.tscn")

@export var textures:Array[Texture]

#drag node and release while pressing ctrl. make sure type is set as Head as this will help with autocomplete

#drag node and release while pressing ctrl. make sure type is set as Head as this will help with autocomplete
@onready var head = $Head
#@onready var tail: 
@onready var bounds = $Bounds
@onready var spawner = $Spawner
@onready var hud = $HUD
@onready var melon_spawn_timer = $MelonSpawnTimer
@onready var despawn_melon_timer = $DespawnMelonTimer
const MELON = preload("res://gameplay/melon.tscn")

#@onready var tail = $Tail

#@onready var snake_parts: SnakeParts = %SnakeParts as SnakeParts
#@onready var snakebody = %snakebody


#set interval between snake movement
var level = Levels.Database[Global.current_level]
var time_between_moves:float = 1000.0
var time_since_last_move:float = 0
var speed:float = level.speed
var pooping_speed = 10
# sets moving direction at start of game. most game start moving left to right, I changed it to up becasue it's for mobile phone
var move_dir:Vector2 = Vector2.UP #(Vector2(0,-1)
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
	head.food_eaten.connect(_on_food_eaten)
	head.collided_with_tail.connect(_on_tail_collided)
	spawner.tail_added.connect(_on_tail_added)
	#hud.decrease_snake_length.connect(_on_decrease_snake_length)
	time_since_last_move = time_between_moves
	snake_parts.push_front(head) # tutorial was using push_back, but I think this is more correct? research
	initialize_snake()
	spawner.spawn_food()

	
	
	
func initialize_snake():
	var starting_snake_length = level.starting_length	
	spawner.call_deferred("spawn_tail", snake_parts[snake_parts.size()-1].last_position, starting_snake_length)


# sets user input. ui_up (or maybe it's the uppercase direction?) refers to keyboard keys and joypad buttons. Add ASWD in Project Settings
func _process(_delta) -> void: #not sure I know what this void is

	if Input.is_action_pressed("ui_up"): 
		if (move_dir != Vector2.DOWN):
			move_dir = Vector2.UP #(0,-1)
			head.rotation_degrees = 0.0
	if Input.is_action_pressed("ui_down"):
		if (move_dir != Vector2.UP):
			move_dir = Vector2.DOWN #(0,1)
			head.rotation_degrees = 180.0
	if Input.is_action_pressed("ui_left"):
		if (move_dir != Vector2.RIGHT):
			move_dir = Vector2.LEFT #(-1,0)
			head.rotation_degrees = 270.0
	if Input.is_action_pressed("ui_right"):
		if (move_dir != Vector2.LEFT):
			move_dir = Vector2.RIGHT #(1,0)
			head.rotation_degrees = 90.0

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
	
var poop_array = []

func detach_tail():
	if (snake_parts.size() > 1):
		var new_poop = snake_parts.pop_back()
		decrease_snake_length.emit()
		new_poop.get_node("Sprite2D").texture = textures[0]
		poop_array.push_back(new_poop)
	

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
	if (level.has_prunes):
		spawner.call_deferred("spawn_prune")

func _on_hud_decrease_snake_length():
	hud.decrease_snake_length()



func _on_mouse_spawn_timer_timeout():
	return spawner.spawn_enemy()


func _on_head_mouse_eaten():
	spawner.spawn_tail(snake_parts[snake_parts.size()-1].last_position, 3)


func _on_poop_despawn_timer_timeout():
	if poop_array.size() > 1:
		var poop_to_despawn = poop_array.pop_front()
		poop_to_despawn.queue_free()


func _on_head_melon_eaten():
	for i in poop_array.size():
		var poop_to_despawn = poop_array.pop_front()
		poop_to_despawn.queue_free()
		

func spawn_on_half_length():

	if snake_parts.size() == level.starting_length / 2:
		spawner.spawn_melon()
		melon_spawn_timer.stop()


func _on_melon_spawn_timer_timeout():
	spawn_on_half_length()


