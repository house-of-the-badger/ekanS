class_name Tail extends SnakeParts

const GAMEPLAY = preload("res://gameplay/gameplay.tscn")


@export var textures:Array[Texture]

@onready var sprite_2d: Sprite2D = $Sprite2D
var gameplay = GAMEPLAY

func _ready():
	pass
	#var snake_parts:Array[SnakePart] = []
	#for n in 10:
		#snake_parts.push_back(sprite_2d.texture)
	sprite_2d.texture = textures[0]
	#gameplay.tail_despawned.connect(_on_tail_despawned)
	
func _on_tail_despawned():
	sprite_2d.texture = textures[1]

