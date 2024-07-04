class_name Prune extends Area2D

signal prune_spawned_on_poop

func _on_area_entered(area):
	if area.is_in_group("poop"):
		prune_spawned_on_poop.emit()
		
