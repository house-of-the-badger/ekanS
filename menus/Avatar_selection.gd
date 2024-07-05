class_name AvatarSelection extends Control


var COLLECTION_NAME_PLAYERS = "players"
#var COLLECTION_NAME_AVATARS = "avatars"
#var DOCUMENT_ID = "avatar_1"
@onready var snake_1 = %Snake1
@onready var snake_2 = %Snake2
@onready var snake_3 = %Snake3
var avatar_id 
var avatar_img



func _ready():
	#var collection: FirestoreCollection = Firebase.Firestore.collection(COLLECTION_NAME_AVATARS)
	#var document = await collection.get_doc(DOCUMENT_ID)
	#print(document)	
	pass


func _process(delta):
	pass


func _on_snake_1_pressed():
	avatar_id = snake_1
	avatar_img = "gs://project-ekans.appspot.com/snake1.png"


func _on_snake_2_pressed():
	avatar_id = snake_2
	avatar_img = "gs://project-ekans.appspot.com/snake2.png"


func _on_snake_3_pressed():
	avatar_id = snake_3
	avatar_img = "gs://project-ekans.appspot.com/snake3.png"


func _on_confirm_button_pressed():
	save_data()

func save_data():
	var auth = Firebase.Auth.auth
	print(auth.localid)
	if auth.localid:
		var firestore_collection: FirestoreCollection= Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
		var username = %Username.text
		
		var document = await firestore_collection.get_doc(auth.localid)
		if document:
			document.add_or_update_field("username", username)
			document.add_or_update_field("avatar_id", avatar_id)
			document.add_or_update_field("avatar_img", avatar_img)
			await firestore_collection.update(document)
		else:
			var data : Dictionary= {
			"username":username,
			"avatar_id":avatar_id,
			"avatar_img":avatar_img,
		}
			document = await firestore_collection.add(auth.localid, 		data)


func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://menus/SignUp.tscn")
