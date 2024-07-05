extends GutTest
#func before_each():
	#gut.p("ran setup", 2)
#
#func after_each():
	#gut.p("ran teardown", 2)
#
#func before_all():
	#gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)
func test_initialise_snake():
	 # Simulate retrieving snake length from Firebase
	var preset_length = 56  # Example: Assume we retrieve the length from Firebase
	var gameplay_instance = Gameplay.new()
	gameplay_instance.initialize_snake()
	# Assert that the snake_parts array has been initialized with the correct length
	assert_eq(gameplay_instance.snake_parts.size(), preset_length, "Snake should start with preset length")
	# Add more specific assertions if needed based on your game logic and Firebase data
	
	

