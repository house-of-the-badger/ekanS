class_name SnakeParts extends Area2D #inherits from Area2D

var last_position:Vector2

func move_to(new_position:Vector2):
	last_position = self.position
	self.position = new_position
