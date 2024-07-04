class_name HUD extends CanvasLayer

@onready var score: Label = %Score
@onready var snake_length: Label = %SnakeLength

var new_snake_length = Global.starting_snake_length

func _ready():
	snake_length.text = "Snake Length: " + str(new_snake_length)

func update_score(n:int):
	score.text = "Score: " + str(n)


func _on_gameplay_decrease_snake_length():
	new_snake_length -= 1
	snake_length.text = "Snake Length: " + str(new_snake_length)
	print(new_snake_length)
