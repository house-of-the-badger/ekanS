class_name Spawner extends Node2D
#signals
signal tail_added(tail:Tail)

@onready var head = %Head
#export vars
@export var bounds:Bounds


#instatiating packed scenes
var food_scene:PackedScene = preload("res://gameplay/food.tscn") #preloads food into memory so instantiation is faster
var tail_scene:PackedScene = preload("res://gameplay/tail.tscn")
var prune_scene:PackedScene = preload("res://gameplay/prune.tscn")
func _ready() -> void:
	pass
	#var food = food_scene.instantiate()
	#food.spawned_on_poop.connect(prevents_spawn_food)

func spawn_food():
	# 1 where to spawn food
	var spawn_point:Vector2 = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Global.CELL_SIZE, bounds.x_max - Global.CELL_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.CELL_SIZE, bounds.y_max - Global.CELL_SIZE)
	# spawn point is divided by grid cell and round down to nearest integer. this so that apple appears centered in tile
	spawn_point.x = floorf(spawn_point.x / Global.CELL_SIZE) * Global.CELL_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.CELL_SIZE) * Global.CELL_SIZE
	# 2 what we are spawning (instantiating)
	var food = food_scene.instantiate()
	food.position = spawn_point
	food.spawned_on_poop.connect(prevents_spawn_food)
	# 3 where we are putting it (parenting)
	call_deferred("add_child", food) #parent of spawner is gameplay, so we are adding child food to gameplay. this method works for simple projects

func spawn_prune():
	# 1 where to spawn prune
	var spawn_point:Vector2 = Vector2.ZERO
	spawn_point.x = randf_range(bounds.x_min + Global.CELL_SIZE, bounds.x_max - Global.CELL_SIZE)
	spawn_point.y = randf_range(bounds.y_min + Global.CELL_SIZE, bounds.y_max - Global.CELL_SIZE)
	# spawn point is divided by grid cell and round down to nearest integer. this so that apple appears centered in tile
	spawn_point.x = floorf(spawn_point.x / Global.CELL_SIZE) * Global.CELL_SIZE
	spawn_point.y = floorf(spawn_point.y / Global.CELL_SIZE) * Global.CELL_SIZE
	# 2 what we are spawning (instantiating)
	var prune = prune_scene.instantiate()
	prune.position = spawn_point
	prune.prune_spawned_on_poop.connect(prevents_spawn_prune)
	get_parent().add_child(prune)

func spawn_tail(pos:Vector2):
	var head_position = head.position
	print(Global.starting_snake_length)
	for i in Levels.Database[Global.current_level].starting_length:
		var tail:Tail = tail_scene.instantiate() as Tail
		tail.position = pos + Vector2(head_position.x, (i + 9) * Global.CELL_SIZE)
		get_parent().add_child(tail)
		tail_added.emit(tail)

func despawn_last_node_in_group(group_name):
	var nodes_in_group = get_tree().get_nodes_in_group(group_name)
	if nodes_in_group.size() > 0:
		nodes_in_group.back().queue_free()
		
func prevents_spawn_food():
	print("tried to spawn food")
	despawn_last_node_in_group("food")
	spawn_food()
	
func prevents_spawn_prune():
	print("tried to spawn prune")
	despawn_last_node_in_group("prune")
	spawn_prune()
