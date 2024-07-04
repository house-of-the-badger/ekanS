class_name AvatarSelection extends Control


var COLLECTION_NAME = "players"
@onready var snake_1 = %Snake1
@onready var snake_2 = %Snake2
@onready var snake_3 = %Snake3
var avatar_id 
var avatar_img



func _ready():
	pass 


func _process(delta):
	pass


func _on_snake_1_pressed():
	avatar_id = snake_1
	avatar_img


func _on_snake_2_pressed():
	pass # Replace with function body.


func _on_snake_3_pressed():
	pass # Replace with function body.


func _on_confirm_button_pressed():
	save_data()

func save_data():
	var auth = Firebase.Auth.auth
	print(auth)
	if auth.localid:
		var collection: FirestoreCollection= Firebase.Firestore.collection(COLLECTION_NAME)
		var username = %Username.text
		var data : Dictionary= {
			"username":username
		}
		var document = await collection.add(auth.localid, 		data)
