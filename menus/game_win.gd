class_name GameWin extends CanvasLayer
@onready var level_score = %LevelScore
@onready var high_score = %HighScoreLabel


func set_score(n:int):
	level_score.text = "Level Score: " + str(n)
	if n > Global.save_data.high_score:
		high_score.visible = true
		Global.save_data.high_score = n
		Global.save_data.save()
	else:
		high_score.visible = false

func _on_next_level_pressed():
	Global.current_level = "level" + str(int(Global.current_level) + 1)
	get_tree().reload_current_scene()
	

func _on_quit_pressed():
	get_tree().quit()

func _notification(what):
	match what:
		NOTIFICATION_ENTER_TREE:
			get_tree().paused = true
		NOTIFICATION_EXIT_TREE:
			get_tree().paused = false
