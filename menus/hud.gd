class_name HUD extends CanvasLayer

signal decrease_snake_length

@onready var score = $Panel/MarginContainer/HBoxContainer/Score
@onready var snake_length = $Panel/MarginContainer/HBoxContainer/SnakeLength

var new_snake_length = Levels.Database[Global.current_level].starting_length

func _ready():
	pass
	snake_length.text = "Snake Length: " + str(new_snake_length)

func update_score(n:int):
	score.text = "Score: " + str(n)


func _on_gameplay_decrease_snake_length():
	new_snake_length -= 1
	snake_length.text = "Snake Length: " + str(new_snake_length)
	print(new_snake_length)
