class_name GetAvatars extends Node

@onready var avatar_01 = %Avatar1
@onready var avatar_02 = %Avatar2
@onready var avatar_03 = %Avatar3
@onready var avatar_04 = %Avatar4
@onready var avatar_05 = %Avatar5
@onready var avatar_06 = %Avatar6

var FOLDER_REFERENCE = "avatars"
var texture_buttons = []
var textures = []
var urls = []

func _ready():
	texture_buttons.append(avatar_01)
	texture_buttons.append(avatar_02)
	texture_buttons.append(avatar_03)
	texture_buttons.append(avatar_04)
	texture_buttons.append(avatar_05)
	texture_buttons.append(avatar_06)
	
	load_images_from_firebase()
	
func load_images_from_firebase() -> void:
	var folder_ref = Firebase.Storage.ref(FOLDER_REFERENCE)
	var paths_array = await folder_ref.list_all() #gives an array of /avatars/:avatar_id
	if paths_array.size() > 0:
		for file_path in paths_array:
			var file_ref = Firebase.Storage.ref(file_path)
			var data_task = await file_ref.get_data()
			process_image_data(data_task)
	else:
		print("No objects found in storage path")
		
func process_image_data(data: PackedByteArray):
	var image = Image.new()
	
	image.load_png_from_buffer(data)
	if image:
		var target_width = 100.0
		var aspect_ratio = float(image.get_width()) / float(image.get_height())
		var target_height = target_width / aspect_ratio
		image.resize(target_width, target_height)
		var texture = ImageTexture.new()
		texture.set_image(image) 
		textures.append(texture)
		if textures.size() == texture_buttons.size():
			assign_textures_to_buttons()
	else:
		print("Failed to load image from buffer")

		
func assign_textures_to_buttons():
	for i in range(texture_buttons.size()):
		if i < textures.size():
			var texture_button = texture_buttons[i]
			var texture = textures[i]
			if texture.get_width() > 0 and texture.get_height() > 0:
				texture_button.texture_normal = texture
			else:
				print("Invalid texture for button:", texture_button.name)
				

