extends CanvasLayer

@onready var score = $Panel/MarginContainer/HBoxContainer/Score
@onready var snake_length = $Panel/MarginContainer/HBoxContainer/SnakeLength


@export var new_snake_length:int = Levels.Database[Global.current_level].starting_length

func _ready():
	snake_length.text = "Snake Length: " + str(new_snake_length)
	

func update_score(n:int):
	score.text = "Score: " + str(n)


func _on_gameplay_decrease_snake_length():
	new_snake_length -= 1
	snake_length.text = "Snake Length: " + str(new_snake_length)
