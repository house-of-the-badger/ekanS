class_name SnakeParts extends Area2D #inherits from Area2D

#@onready var head = %Head
#@onready var tail = %Tail

var last_position:Vector2
#var snake_parts:Array[SnakeParts] = []

#func _ready():
	#snake_parts.push_front(head)
	#snake_parts.push_back(tail)

func move_to(new_position:Vector2):
	last_position = self.position
	self.position = new_position
