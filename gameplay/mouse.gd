extends CharacterBody2D

@onready var bounds = %Bounds


var speed = 50
var motion = Vector2() 
var gravity = 1
var direction = 1 
var last_position:Vector2


func _physics_process(delta):
	motion.y += gravity
	motion.x = speed * direction 
	move_and_collide(motion * delta)

func move_to(new_position:Vector2):
	last_position = self.position
	self.position = new_position


# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
