extends Control

@onready var player_avatar = %PlayerAvatar

func _ready():
	print("User profile scene ready")
	var auth = Firebase.Auth.auth
	if auth.localid:
		print("Local ID found in user profile:", auth.localid)
		DatabaseManager.player_data_changed.connect(_on_player_data_changed)
		DatabaseManager.get_player_data(auth.localid)
	else:
		print("No local ID found")
			
func _on_player_data_changed(data: Dictionary) -> void:
	print("Fetched player data:", data)
	if data.has("username"):
		print("Setting username:", data["username"]["stringValue"])
		%SnakeNameLabel.text = data["username"]["stringValue"]
	if data.has("score"):
		print("Setting score:", data["score"]["integerValue"])
		%TotalScoreLabel.text = data["score"]["integerValue"]
	if data.has("avatar_img"):
		print("Loading avatar image from path:", data["avatar_img"]["stringValue"])
		load_images_from_path(data["avatar_img"]["stringValue"])


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://menus/start_screen.tscn")

func load_images_from_path(path:String) -> void:
	print("Fetching image from Firebase Storage at path:", path)
	var file_ref = Firebase.Storage.ref(path)
	var data_task = await file_ref.get_data()
	_on_data_received(data_task)

func _on_data_received(data: PackedByteArray):
	print("Processing image data")
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

		

func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://menus/Login.tscn")


func _on_edit_button_pressed():
	get_tree().change_scene_to_file("res://menus/Avatar_selection.tscn")
