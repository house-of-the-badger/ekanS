extends Camera2D

signal swipe_right
signal swipe_left
signal swipe_up
signal swipe_down

var swipe_start: Vector2
var swipe_threshold: float = 50.0  #Minimum swipe distance to be considered a swipe

func _ready():
	set_process_input(true)  #Enable input handling

func _input(event):
	#Handle touch swipe events
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.position
		else:
			var swipe_end = event.position
			detect_touch_swipe(swipe_end)

func detect_touch_swipe(swipe_end: Vector2):
	var swipe_vector = swipe_end - swipe_start
	if swipe_vector.length() >= swipe_threshold:
		if abs(swipe_vector.x) > abs(swipe_vector.y):
			if swipe_vector.x > 0:
				emit_signal("swipe_right")
			else:
				emit_signal("swipe_left")
		else:
			if swipe_vector.y > 0:
				emit_signal("swipe_down")
			else:
				emit_signal("swipe_up")
