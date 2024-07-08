extends Timer

var level = Levels.Database[Global.current_level]

# Called when the node enters the scene tree for the first time.
func _ready():

	autostart = false

	if level.mouse.has_mouse:
		autostart = true
		wait_time = level.mouse.spawn_timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
