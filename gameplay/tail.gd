class_name Tail extends SnakeParts

const GAMEPLAY = preload("res://gameplay/gameplay.tscn")


@export var textures:Array[Texture]

@onready var sprite_2d: Sprite2D = $Sprite2D
var gameplay = GAMEPLAY

func _ready():
	sprite_2d.texture = textures[0]
	
func _on_tail_despawned():
	sprite_2d.texture = textures[1]

