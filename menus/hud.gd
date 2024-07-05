class_name HUD extends CanvasLayer
signal decrease_snake_length


@onready var score = $Panel/MarginContainer/HBoxContainer/Score
@onready var snake_length = $Panel/MarginContainer/HBoxContainer/SnakeLength

@export var new_snake_length:int = Levels.Database[Global.current_level].starting_length

func _ready():
	snake_length.text = "Snake Length: " + str(new_snake_length)
	
	
func update_score(n:int):
	new_snake_length -= 1
	snake_length.text = "Snake Length: " + str(new_snake_length)