class_name Food extends Area2D

signal spawned_on_poop

func _on_area_entered(area):
	if area.is_in_group("poop"):
		spawned_on_poop.emit()
		
