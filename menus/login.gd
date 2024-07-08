extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)



func _on_login_button_pressed():
	var email = %EmailInput.text
	var password = %PasswordInput.text
	%LoginStateLabel.text = "Logging in..."
	Firebase.Auth.login_with_email_and_password(email, password)

func on_login_succeeded(auth):
	%LoginStateLabel.text = "You are logged in!"
	Firebase.Auth.save_auth(auth)
	get_tree().change_scene_to_file("res://menus/Avatar_selection.tscn")
	
func on_login_failed(error_code, message):
	%LoginStateLabel.text = "%s" % message


func _on_signup_button_pressed():
	get_tree().change_scene_to_file("res://menus/sign-up.tscn")
