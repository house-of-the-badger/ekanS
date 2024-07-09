class_name Bounds extends Node2D
#game area bounds, so that snake can appear from opposite side when it leaves the grid

@onready var upper_left: Marker2D = %UpperLeft
@onready var lower_right: Marker2D = %LowerRight

var x_max:float
var x_min:float
var y_max:float
var y_min:float

func _ready() -> void: #void functions don't return a value. Printing the return value from a void function would give Null. 
	x_max = lower_right.position.x
	x_min = upper_left.position.x
	y_max = lower_right.position.y
	y_min = upper_left.position.y

func wrap_vector(v:Vector2) -> Vector2: #takes a Vector2 and returns a Vector2
	if v.x > x_max:
		return Vector2(x_min,v.y)
	if v.x < x_min:
		return Vector2(x_max,v.y)
	if v.y > y_max:
		return Vector2(v.x,y_min)
	if v.y < y_min:
		return Vector2(v.x,y_max)
	return v

