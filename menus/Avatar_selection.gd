class_name AvatarSelection extends Control

@onready var get_avatars = %GetAvatars

var avatar_id:int
var avatar_img:String
var avatar_color:String

func _ready():
	print("i'm in avatar selection")
	
			
func _on_confirm_button_pressed():
	await update_data()
	get_tree().change_scene_to_file("res://menus/user_profile.tscn")

func update_data():
	var auth = Firebase.Auth.auth
	print(avatar_id)
	print(avatar_img)
	
	if auth.localid:
		print(auth.localid, "local id in avatar selection")
		await DatabaseManager.update_player_data(auth.localid, %Username.text, avatar_id, avatar_img, avatar_color)
		%UsernameStateLabel.text = "Your snake was updated"
	else:
		print("Error: User not authenticated")


func _on_logout_button_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://menus/Login.tscn")


func _on_avatar_1_pressed():
	print("selected avatar 01")
	set_avatar(1, "avatars/avatar_01.png", "yellow")


func _on_avatar_2_pressed():
	print("selected avatar 02")
	set_avatar(2, "avatars/avatar_02.png", "orange")


func _on_avatar_3_pressed():
	print("selected avatar 03")
	set_avatar(3, "avatars/avatar_03.png", "green")


func _on_avatar_4_pressed():
	print("selected avatar 04")
	set_avatar(4, "avatars/avatar_04.png", "purple")


func _on_avatar_5_pressed():
	print("selected avatar 05")
	set_avatar(5, "avatars/avatar_05.png", "blue")


func _on_avatar_6_pressed():
	print("selected avatar 06")
	set_avatar(6, "path/to/avatar_06.png", "pink")

func set_avatar(id:int, img_path:String, avatar_color:String):
	avatar_id = id
	avatar_img = img_path
	
