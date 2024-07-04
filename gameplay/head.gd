class_name Head extends SnakeParts #remember OOP and classes. inherits from SnakePart

signal food_eaten
signal collided_with_tail
signal prune_eaten

func _on_area_entered(area):
	# print("collided with ", area.name)
	if area.is_in_group("food"):
		# collided with food
		food_eaten.emit()
		#area.queue_free() this can also be used, but in the tutorial it created an error and was changed. to be researched
		area.call_deferred("queue_free")
	elif area.is_in_group("prune"):
		prune_eaten.emit()
		area.call_deferred("queue_free")
	else:
		#collided with something that isn't food
		collided_with_tail.emit()
		
