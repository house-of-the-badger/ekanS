extends Area2D

signal melon_spawned_on_poop

func _on_area_entered(area):
	if area.is_in_group("poop"):
		melon_spawned_on_poop.emit()
		


func _on_despawn_timer_timeout():
	queue_free()
