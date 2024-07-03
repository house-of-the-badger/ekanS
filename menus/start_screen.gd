class_name StartScreen extends CanvasLayer

const gameplay_scene:PackedScene = preload("res://gameplay/gameplay.tscn")

@onready var score: Label = %ScoreLabel
@onready var start: Button = %StartButton
@onready var quit = %QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var high_score:int = Global.save_data.high_score
	score.text = "High Score: " + str(high_score)
	#Global.save_data.high_score = 10
	#Global.save_data.save()

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(gameplay_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
