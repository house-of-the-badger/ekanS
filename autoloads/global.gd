extends Node

const  CELL_SIZE:int = 32

var save_data:SaveData

var starting_snake_length = 20

func _ready():
	save_data = SaveData.load_or_create()
