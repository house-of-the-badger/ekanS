class_name Spawner extends Node2D
#signals
signal tail_added(tail: Tail)

@onready var head = %Head
#export vars
@export var bounds: Bounds

#instatiating packed scenes
var food_scene: PackedScene = preload ("res://gameplay/food.tscn") # preloads food into memory so instantiation is faster
var tail_scene: PackedScene = preload ("res://gameplay/tail.tscn")
var prune_scene: PackedScene = preload ("res://gameplay/prune.tscn")
var mouse_scene: PackedScene = preload ("res://gameplay/mouse.tscn")
var melon_scene: PackedScene = preload ("res://gameplay/melon.tscn")

func _ready() -> void:
	pass

#Spawn functions

func spawn_tail(pos: Vector2, tails_to_add):
	var head_position = head.position
	for i in tails_to_add:
		var tail: Tail = tail_scene.instantiate() as Tail
		tail.position = pos + Vector2(head_position.x, (i + 9) * Global.CELL_SIZE)
		get_parent().add_child(tail)
		tail_added.emit(tail)

func spawn_food():
	var spawn_point = get_random_spawn_point()
	spawn_point = align_to_grid(spawn_point)
	var food = instantiate_food(spawn_point)
	get_parent().add_child(food)

func spawn_prune():
	var spawn_point = get_random_spawn_point()
	spawn_point = align_to_grid(spawn_point)
	var prune = instantiate_prune(spawn_point)
	get_parent().add_child(prune)
	
func spawn_melon():
	var spawn_point = get_random_spawn_point()
	spawn_point = align_to_grid(spawn_point)
	var melon = instantiate_melon(spawn_point)
	get_parent().add_child(melon)

func spawn_enemy():
	var spawn_point = get_random_spawn_point()
	spawn_point = align_to_grid(spawn_point)
	var mouse = instantiate_mouse(spawn_point)
	get_parent().add_child(mouse)
	
# instantiate functions

func instantiate_mouse(position: Vector2) -> Node2D:
	var mouse = mouse_scene.instantiate()
	mouse.position = position
	#mouse.mouse_spawned_on_poop.connect(prevents_spawn_mouse)
	return mouse
	
func instantiate_prune(position: Vector2) -> Node2D:
	var prune = prune_scene.instantiate()
	prune.position = position
	prune.prune_spawned_on_poop.connect(prevents_spawn_prune)
	return prune
	
func instantiate_melon(position: Vector2) -> Node2D:
	var melon = melon_scene.instantiate()
	melon.position = position
	melon.melon_spawned_on_poop.connect(prevents_spawn_melon)
	return melon

func instantiate_food(position: Vector2) -> Node2D:
	var food = food_scene.instantiate()
	food.position = position
	food.spawned_on_poop.connect(prevents_spawn_food)
	return food
		
# Spawn prevention functions

func prevents_spawn_food():
	despawn_last_node_in_group("food")
	spawn_food()
	
func prevents_spawn_prune():
	despawn_last_node_in_group("prune")
	spawn_prune()
	
func prevents_spawn_melon():
	despawn_last_node_in_group("melon")
	spawn_melon()
	

# Utility Functions

func get_random_spawn_point() -> Vector2:
	var spawn_point = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Global.CELL_SIZE, bounds.x_max - Global.CELL_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.CELL_SIZE, bounds.y_max - Global.CELL_SIZE)
	return spawn_point
	
func align_to_grid(point: Vector2) -> Vector2:
	point.x = floorf(point.x / Global.CELL_SIZE) * Global.CELL_SIZE
	point.y = floorf(point.y / Global.CELL_SIZE) * Global.CELL_SIZE
	return point

func despawn_last_node_in_group(group_name):
	var nodes_in_group = get_tree().get_nodes_in_group(group_name)
	if nodes_in_group.size() > 0:
		nodes_in_group.back().queue_free()
