extends Node

const  CELL_SIZE:int = 32

var save_data:SaveData

var counter = 0

var current_level = "level1"
var starting_snake_length = Levels.Database[current_level].starting_length


func _ready():
	save_data = SaveData.load_or_create()
	print(Levels.Database[current_level])
