class_name AvatarSelection extends Control

@onready var get_avatars = %GetAvatars

var COLLECTION_NAME_PLAYERS = "players"
var avatar_id:int
var avatar_img:String

func _ready():
	pass

func _on_confirm_button_pressed():
	save_data()
	get_tree().change_scene_to_file("res://menus/user_profile.tscn")

func save_data():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var firestore_collection: FirestoreCollection= Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
		var username = %Username.text
		
		var document = await firestore_collection.get_doc(auth.localid)
		print(document)
		if document && not document.is_null_value("username"):
			print("Document exists, updating fields")
			%UsernameStateLabel.text = "Your snake was updated"
			document.add_or_update_field("username", username)
			document.add_or_update_field("avatar_id", avatar_id)
			document.add_or_update_field("avatar_img", avatar_img)
			await firestore_collection.update(document)
		else:
			print("Document does not exist, creating new document")
			%UsernameStateLabel.text = "Your snake was saved"
			var data : Dictionary= {
			"username":username,
			"avatar_id":avatar_id,
			"avatar_img":avatar_img,
		}
			document = await firestore_collection.add(auth.localid, data)

func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://menus/Login.tscn")


func _on_avatar_1_pressed():
	set_avatar(1, "avatars/avatar_1.png")


func _on_avatar_2_pressed():
	set_avatar(2, "avatars/avatar_2.png")


func _on_avatar_3_pressed():
	set_avatar(3, "avatars/avatar_3.png")


func _on_avatar_4_pressed():
	set_avatar(4, "avatars/avatar_4.png")


func _on_avatar_5_pressed():
	set_avatar(5, "avatars/avatar_5.png")


func _on_avatar_6_pressed():
	set_avatar(6, "path/to/avatar_6.png")

func set_avatar(id:int, img_path:String):
	avatar_id = id
	avatar_img = img_path
	
