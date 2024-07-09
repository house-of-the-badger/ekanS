class_name Head extends SnakeParts

signal food_eaten
signal collided_with_tail
signal prune_eaten
signal mouse_eaten
signal melon_eaten

func _on_area_entered(area):
	if area.is_in_group("food"):
		_handle_food_collision(area)
	elif area.is_in_group("prune"):
		_handle_prune_collision(area)
	elif area.is_in_group("mouse"):
		_handle_mouse_collision(area)
	elif area.is_in_group("melon"):
		_handle_melon_collision(area)
	else:
		_handle_tail_collision()

func _on_body_entered(body):
	mouse_eaten.emit()
	body.queue_free()

func _handle_food_collision(area):
	food_eaten.emit()
	area.call_deferred("queue_free")

func _handle_prune_collision(area):
	prune_eaten.emit()
	area.call_deferred("queue_free")
	
func _handle_melon_collision(area):
	melon_eaten.emit()
	area.call_deferred("queue_free")

func _handle_mouse_collision(area):
	mouse_eaten.emit()
	area.call_deferred("queue_free")

func _handle_tail_collision():
	collided_with_tail.emit()
