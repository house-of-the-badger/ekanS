extends Control

@onready var player_avatar = %PlayerAvatar

var COLLECTION_NAME_PLAYERS = "players"
var avatar_id:int
var avatar_img:String


func _ready():
	var auth = Firebase.Auth.auth
	if auth.localid:
		var firestore_collection: FirestoreCollection= Firebase.Firestore.collection(COLLECTION_NAME_PLAYERS)
		var document = await firestore_collection.get_doc(auth.localid)
		if document:
			var data = document.document
			if data.has("username"):
				%SnakeNameLabel.text = data["username"]["stringValue"]
			if data.has("score"):
				%TotalScoreLabel.text = data["score"]["integerValue"]
			if data.has("avatar_img"):
				load_images_from_path(data["avatar_img"]["stringValue"])
		
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menus/start_screen.tscn")

func load_images_from_path(path:String) -> void:
	var file_ref = Firebase.Storage.ref(path)
	var data_task = await file_ref.get_data()
	_on_data_received(data_task)

func _on_data_received(data: PackedByteArray):
	var image = Image.new()
	image.load_png_from_buffer(data)
	if image:
		var target_width = 250.0
		var aspect_ratio = float(image.get_width()) / float(image.get_height())
		var target_height = target_width / aspect_ratio
		image.resize(target_width, target_height)
		var texture = ImageTexture.new()
		texture.set_image(image) 
		player_avatar.set_texture(texture)
	else:
		print("Failed to load image from buffer")

		
