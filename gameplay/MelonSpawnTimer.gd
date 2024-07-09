extends Timer

var level = Levels.Database[Global.current_level]

# Called when the node enters the scene tree for the first time.
func _ready():

	autostart = false

	if level.melon.has_melon:
		autostart = true
		#wait_time = level.melon.spawn_timer
